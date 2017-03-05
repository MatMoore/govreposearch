class Crawler
  class TryAgainError < StandardError
    attr_accessor :delay_in_seconds

    def initialize(delay_in_seconds, msg="Try again in #{delay_in_seconds}")
      @delay_in_seconds = delay_in_seconds
      super(msg)
    end
  end

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

  def initialize(github_client: Crawler.octokit_client)
    @github_client = github_client
    @no_licence = []
    @number_seen = 0
    @number_valid = 0
  end

  def rate_limit
    github_client.rate_limit
  end

  def repositories_for_organisation(organisation)
    begin
      repositories = crawl_organisation(organisation)

    rescue Octokit::TooManyRequests
      rate_limit = crawler.rate_limit
      Rails.logger.error("Rate limit hit: waiting until #{rate_limit.resets_at}")

      raise TryAgainError.new(rate_limit.resets_in)

    rescue Faraday::ConnectionFailed, Faraday::TimeoutError
      raise TryAgainError.new(1)
    end

    repositories
  end

  def self.octokit_client
    key = ENV['GITHUB_API_KEY']

    if key.nil?
      Rails.logger.warn('GITHUB_API_KEY not set in environment or .env file. Github API requests will be rate limited to 60/hour.')
      Rails.logger.warn('Go to https://github.com/settings/tokens to generate a new token.')
      Octokit::Client.new(auto_paginate: true)
    else
      Octokit::Client.new(access_token: key, auto_paginate: true)
    end
  end

private

  attr_reader :github_client
  attr_writer :number_seen
  attr_writer :number_valid

  def crawl_organisation(organisation)
    response = github_client.repositories(
      organisation.github_name,
      headers: headers
    )

    response.map do |repo_response|
      crawl_repository(
        organisation: organisation,
        repo_response: repo_response
      )
    end.compact
  end

  def crawl_repository(organisation:, repo_response:)
    self.number_seen += 1

    readme = github_client.readme(
      repo_response[:full_name],
      accept: 'application/vnd.github.v3.raw',
      headers: headers
    ).force_encoding('UTF-8')

    if has_licence?(full_name: repo_response[:full_name], readme: readme)
      self.number_valid += 1

      Repository.new(
        repo_response[:name],
        repo_response[:full_name],
        organisation.group,
        organisation.github_name,
        repo_response[:html_url],
        readme,
        repo_response["created_at"],
        repo_response["pushed_at"],
        repo_response["stargazers_count"],
        repo_response["watchers_count"],
        repo_response["forks_count"],
        [repo_response["language"]],
        repo_response["description"]
      )
    else
      self.no_licence << repo_response[:full_name]
      Rails.logger.debug("Can't find licence for #{repo_response[:full_name]}")
      nil
    end

  rescue Octokit::NotFound
    # We're not interested in anything without a readme or licence.
    Rails.logger.debug("Can't find readme for #{repo_response[:full_name]}")
    nil
  rescue Octokit::UnavailableForLegalReasons
    # DMCA bullshit
    Rails.logger.debug("Readme unavailable for legal reasons for #{repo_response[:full_name]}")
    nil
  end

  def has_licence?(full_name:, readme:)
    return true if LicenceScraper.scrape_text(readme)

    contents = github_client.contents(
      full_name,
      path: "",
      headers: headers
    )

    contents.any? do |file_response|
      filename = file_response[:name].downcase
      ext = File.extname(filename)
      if ext.blank? || %w(.txt .md .rst).include?(ext)
        /li[sc]ence/ =~ File.basename(filename, ext)
      else
        false
      end
    end
  end

  def headers
    {"Cache-Control" => "public, max-age=31536000"}
  end
end
