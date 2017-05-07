class SearchController < ApplicationController
  def search
    @groups = OrganisationLoader.groups
    @selected_groups = country_groups

    @query = params.fetch(:q, '')
    if @query.present?
      @results = Searcher.new(log: false).search(@query, pagination, country_groups: @selected_groups)
    else
      @results = Searcher.new(log: false).trendy(pagination, country_groups: @selected_groups)
    end
  end

private

  def pagination
    from = params.fetch(:from, '0').to_i
    Pagination.new(10, from)
  end

  def country_groups
    permitted[:country_group] || []
  end

  def permitted
    params.permit(:q, :country_group => [])
  end
end
