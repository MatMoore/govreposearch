require 'elasticsearch/dsl'

module Queries::Search
  extend Elasticsearch::DSL::Search

  def self.query(q, pagination)
    search do
      from pagination.from
      size pagination.page_size
      query do
        multi_match do
          fields ["description", "name", "readme^2", "programming_languages"]
          query q
        end
      end
    end
  end
end
