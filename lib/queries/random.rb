require 'elasticsearch/dsl'

module Query
  extend Elasticsearch::DSL::Search

  def self.random
    search do
      query do
        function_score do
          functions << {random_score: {seed: Random.new_seed.to_s}}
        end
      end
    end
  end
end
