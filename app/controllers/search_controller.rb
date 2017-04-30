class SearchController < ApplicationController
  def search
    @query = params.fetch(:q, '')
    if @query.present?
      @results = Searcher.new(log: false).search(@query)
    else
      @results = Searcher.new(log: false).trendy
    end
  end
end
