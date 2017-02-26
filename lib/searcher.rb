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

private

  attr_reader :client
end
