require_relative "queries/random"
require_relative "queries/similar"

class Searcher
  NAME = 'projects'.freeze

  def initialize(log: true)
    @client = Elasticsearch::Client.new(log: log)
  end

  def search(query)
    ResultSet.from_elasticsearch(
      client.search(
        index: NAME,
        q: query
      )
    )
  end

  def random
    ResultSet.from_elasticsearch(
      client.search(
        index: NAME,
        body: Query.random
      )
    )
  end

  def similar_to(id)
    ResultSet.from_elasticsearch(
      client.search(
        index: NAME,
        body: Query.similar_to(id)
      )
    )
  end

private

  attr_reader :client
end
