require 'elasticsearch/dsl'

module Query
  extend Elasticsearch::DSL::Search

  def self.search_query(q)
    search do
      query do
        multi_match do
          fields ["description", "name", "readme^2", "programming_languages"]
          query q
        end
      end
    end
  end
end
