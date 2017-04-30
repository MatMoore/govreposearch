class Searcher
  NAME = 'projects'.freeze

  def initialize(log: true)
    @client = Elasticsearch::Client.new(log: log)
  end

  def search(query, pagination)
    build_result_set(
      client.search(
        index: NAME,
        body: Queries::Search.query(query, pagination)
      ),
      pagination: pagination
    )
  end

  def random
    build_result_set(
      client.search(
        index: NAME,
        body: Queries::Random.query
      )
    )
  end

  def similar_to(id)
    build_result_set(
      client.search(
        index: NAME,
        body: Queries::Similar.query(id)
      )
    )
  end

  def trendy(pagination)
    build_result_set(
      client.search(
        index: NAME,
        body: Queries::Trendy.query(pagination)
      ),
      pagination: pagination
    )
  end

private

  attr_reader :client

  def build_result_set(elasticsearch_response, pagination: Pagination.new(10, 0))
    total = elasticsearch_response["hits"]["total"]
    results = elasticsearch_response["hits"]["hits"].map do |hit|
      ResultSet::Result.new(
        hit["_score"],
        *hit["_source"].slice(
          "name",
          "web_url",
          "organisation",
          "readme",
          "programming_languages",
          "description"
        ).values
      )
    end

    ResultSet.new(results: results, total: total, pagination: pagination)
  end
end
