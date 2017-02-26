class ElasticsearchPayload
  def initialize(repo)
    @repo = repo
  end

  def id
    repo.full_name
  end

  def body
    {
      name: repo.name,
      organisation_group: repo.organisation_group,
      organisation: repo.organisation,
      web_url: repo.web_url,
      readme: repo.readme,
      licence: repo.licence,
      created_time: repo.created_time,
      last_commit_time: repo.last_commit_time,
      stargazers_count: repo.stargazers_count,
      watchers_count: repo.watchers_count,
      forks_count: repo.forks_count,
      programming_languages: repo.programming_languages
    }
  end

private

  attr_reader :repo
end
