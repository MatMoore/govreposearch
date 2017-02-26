class Crawler
  Repository = Struct.new(
    :name,
    :full_name,
    :organisation_group,
    :organisation,
    :web_url,
    :readme,
    :licence,
    :created_time,
    :last_commit_time,
    #:last_issue_time,
    :stargazers_count,
    :watchers_count,
    :forks_count,
    #:topics,
    #:latest_version,
    :programming_languages
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

        licence = LicenceScraper.scrape_text(readme)

        if licence.nil?
          self.no_licence << response[:full_name]
        else
          self.number_valid += 1
        end

        Repository.new(
          response[:name],
          response[:full_name],
          organisation.group,
          organisation.github_name,
          response[:html_url],
          readme,
          licence,
          response["created_at"],
          response["pushed_at"],
          response["stargazers_count"],
          response["watchers_count"],
          response["forks_count"],
          [response["language"]],
        ) if licence
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
