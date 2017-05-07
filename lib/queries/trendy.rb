require 'elasticsearch/dsl'

module Queries::Trendy
  extend Elasticsearch::DSL::Search

  def self.query(pagination, country_groups: [])
    search do
      from pagination.from
      size pagination.page_size

      query do
        function_score do
          query do
            bool do
              unless country_groups.empty?
                filter do
                  terms organisation_group: country_groups
                end
              end

              must do
                match_all
              end
            end
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
