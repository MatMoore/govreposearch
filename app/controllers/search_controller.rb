class SearchController < ApplicationController
  def search
    query = params.fetch(:q, '')
    @results = Searcher.new(log: false).search(query)
  end
end
