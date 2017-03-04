class ResultSet
  include Enumerable

  attr_reader :total, :results
  delegate :each, to: :results

  def initialize(results:, total:)
    @results = results.dup.freeze
    @total = total
  end

  def self.from_elasticsearch(elasticsearch_response)
    total = elasticsearch_response["hits"]["total"]
    results = elasticsearch_response["hits"]["hits"].map do |hit|
      Result.new(
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

    ResultSet.new(results: results, total: total)
  end

  def inspect
    "ResultSet(results: #{results.map(&:name)}, total: #{total})"
  end

  def to_s
    results.map(&:name).to_s
  end

  Result = Struct.new(
    :score,
    :name,
    :web_url,
    :organisation,
    :readme,
    :programming_languages,
    :description
  )
end
