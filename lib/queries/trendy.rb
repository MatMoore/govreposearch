require 'elasticsearch/dsl'

module Queries::Trendy
  extend Elasticsearch::DSL::Search

  def self.query(pagination)
    search do
      from pagination.from
      size pagination.page_size

      query do
        function_score do
          query do
            match_all
          end

          functions << {
            field_value_factor: {
              field: :stargazers_count,
              modifier: "log1p",
              factor: 1,
            }
          }
        end
      end
    end
  end
end
