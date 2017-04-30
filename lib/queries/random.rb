require 'elasticsearch/dsl'

module Queries::Random
  extend Elasticsearch::DSL::Search

  def self.query
    search do
      query do
        function_score do
          functions << {random_score: {seed: Random.new_seed.to_s}}
        end
      end
    end
  end
end
