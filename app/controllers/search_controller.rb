class SearchController < ApplicationController
  def search
    @query = params.fetch(:q, '')
    if @query.present?
      @results = Searcher.new(log: false).search(@query, pagination)
    else
      @results = Searcher.new(log: false).trendy(pagination)
    end
  end

private

  def pagination
    from = params.fetch(:from, '0').to_i
    Pagination.new(10, from)
  end
end
