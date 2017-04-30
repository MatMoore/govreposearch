class Searcher
  NAME = 'projects'.freeze

  def initialize(log: true)
    @client = Elasticsearch::Client.new(log: log)
  end

  def search(query)
    ResultSet.from_elasticsearch(
      client.search(
        index: NAME,
        body: Queries::Search.query(query)
      )
    )
  end

  def random
    ResultSet.from_elasticsearch(
      client.search(
        index: NAME,
        body: Queries::Random.query
      )
    )
  end

  def similar_to(id)
    ResultSet.from_elasticsearch(
      client.search(
        index: NAME,
        body: Queries::Similar.query(id)
      )
    )
  end

  def trendy
    ResultSet.from_elasticsearch(
      client.search(
        index: NAME,
        body: Queries::Trendy.query
      )
    )
  end

private

  attr_reader :client
end
