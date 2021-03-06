class Index
  NAME = 'projects'.freeze

  def initialize
    @client = Elasticsearch::Client.new(log: true)
  end

  def create_or_replace
    if client.indices.exists(index: NAME)
      client.indices.delete(index: NAME)
    end

    client.indices.create(
      index: NAME,
      body: {
        settings: {
          index: index_settings,
          analysis: analysis_settings,
        },
        mappings: mappings,
      }
    )
  end

  def bulk_upsert(repos)
    client.bulk(
      body: repos.flat_map {|repo| upsert(repo)}
    )
  end

private

  attr_reader :client

  def upsert(repo)
    payload = ElasticsearchPayload.new(repo)

    [
      {
        "update": {
          "_id" => payload.id,
          "_type" => 'repository',
          "_index" => NAME,
          "_retry_on_conflict" => 3,
        },
      },
      {
        "doc" => payload.body,
        "doc_as_upsert" => true
      }
    ]
  end

  def index_settings
    {}
  end

  def analysis_settings
    {}
  end

  def mappings
    {
      repository: {
        properties: {
          name: exact_string,
          description: searchable_string,
          organisation: exact_string,
          organisation_group: exact_string,
          web_url: unsearchable_string,
          readme: searchable_string,
          created_time: timestamp,
          last_commit_time: timestamp,
          last_issue_time: timestamp,
          stargazer_count: integer,
          watcher_count: integer,
          topics: exact_string,
          latest_version: unsearchable_string,
          programming_languages: exact_string,
        },
      }
    }
  end

  def exact_string
    {
      type: "string",
      index: "not_analyzed",
    }
  end

  def unsearchable_string
    {
      type: "string",
      index: "no",
      include_in_all: false,
    }
  end

  def searchable_string
    {
      type: "string",
      index: "analyzed",
    }
  end

  def timestamp
    {
      type: "date",
      include_in_all: false,
    }
  end

  def integer
    {
      type: "integer",
      include_in_all: false,
    }
  end
end
