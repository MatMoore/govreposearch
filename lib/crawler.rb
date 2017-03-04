class Crawler
  Repository = Struct.new(
    :name,
    :full_name,
    :organisation_group,
    :organisation,
    :web_url,
    :readme,
    :created_time,
    :last_commit_time,
    #:last_issue_time,
    :stargazers_count,
    :watchers_count,
    :forks_count,
    #:topics,
    #:latest_version,
    :programming_languages,
    :description
  )

  attr_reader :no_licence
  attr_reader :number_seen
  attr_reader :number_valid

  def initialize(organisations: OrganisationLoader.load, github_client: Crawler.octokit_client)
    @organisations = organisations
    @github_client = github_client
    @no_licence = []
    @number_seen = 0
    @number_valid = 0
  end

  def repositories_for_organisation(organisation)
    github_client.repositories(organisation.github_name).map do |response|
      begin
        self.number_seen += 1

        readme = github_client.readme(response[:full_name], accept: 'application/vnd.github.v3.raw').force_encoding('UTF-8')

        contents = github_client.contents(response[:full_name], :path => "")
        has_license = contents.any? do |file_response|
          filename = file_response[:name].downcase
          ext = File.extname(filename)
          if ext.blank? || %w(txt md rst).include?(ext)
            /li[sc]ence/ =~ File.basename(filename, ext)
          else
            false
          end
        end

        has_licence ||= (!LicenceScraper.scrape_text(readme).nil?)

        if has_licence
          self.number_valid += 1
        else
          self.no_licence << response[:full_name]
          next
        end

        Repository.new(
          response[:name],
          response[:full_name],
          organisation.group,
          organisation.github_name,
          response[:html_url],
          readme,
          response["created_at"],
          response["pushed_at"],
          response["stargazers_count"],
          response["watchers_count"],
          response["forks_count"],
          [response["language"]],
          response["description"]
        )
      rescue Octokit::NotFound
        # We're not interested in anything without a readme or licence.
        nil
      rescue Octokit::UnavailableForLegalReasons
        # DMCA bullshit
        nil
      end
    end.compact
  end

  def each
    return enum_for(:each) unless block_given?

    organisations.each do |organisation|
      repositories_for_organisation(organisation).each do |repo|
        yield repo
      end
    end
  end

  def self.octokit_client
    key = ENV['GITHUB_API_KEY']

    if key.nil?
      Rails.logger.warn('GITHUB_API_KEY not set in environment or .env file. Github API requests will be rate limited to 60/hour.')
      Rails.logger.warn('Go to https://github.com/settings/tokens to generate a new token.')
      Octokit::Client.new
    else
      Octokit::Client.new(access_token: key)
    end
  end

private

  attr_reader :organisations
  attr_reader :github_client
  attr_writer :number_seen
  attr_writer :number_valid
end
