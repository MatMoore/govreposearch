class ResultSet
  include Enumerable

  attr_reader :total, :results
  delegate :each, to: :results

  def initialize(results:, total:, pagination:)
    @results = results.dup.freeze
    @total = total
    @pagination = pagination
  end

  def has_next_page?
    next_page < (total - 1)
  end

  def has_previous_page?
    previous_page != pagination.from
  end

  def previous_page
    full_page_back = (pagination.from - pagination.page_size)
    (full_page_back < 0) ? 0 : full_page_back
  end

  def next_page
    pagination.from + pagination.page_size
  end

  def first_result_number
    pagination.from + 1
  end

  def last_result_number
    pagination.from + results.size
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

private

  attr_reader :pagination
end
