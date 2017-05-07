require 'elasticsearch/dsl'

module Queries::Search
  extend Elasticsearch::DSL::Search

  def self.query(q, pagination, country_groups: [])
    search do
      from pagination.from
      size pagination.page_size
      query do
        bool do
          unless country_groups.empty?
            filter do
              terms organisation_group: country_groups
            end
          end

          must do
            multi_match do
              fields ["description", "name", "readme^2", "programming_languages"]
              query q
            end
          end
        end
      end
    end
  end
end
