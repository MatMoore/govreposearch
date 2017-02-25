class Crawler
  Repository = Struct.new(
    :name,
    :organisation_group,
    :organisation,
    :web_url,
    :readme,
    :license,
    :created_time,
    :last_commit_time,
    :last_issue_time,
    :stargazer_count,
    :watcher_count,
    :topics,
    :latest_version,
    :programming_languages
  )

  def initialize(organisations: OrganisationLoader.load)
    @organisations = organisations
  end

  def repositories_for_organisation(organisation)
    []
  end

  def each
    return enum_for(:each) unless block_given?

    organisations.each do |organisation|
      repositories_for_organisation(organisation).each do |repo|
        yield repo
      end
    end
  end

private

  attr_reader :organisations
end
