require 'elasticsearch/dsl'

module Queries::Similar
  extend Elasticsearch::DSL::Search

  def self.query(id)
    search do
      query do
        more_like_this do
          fields ["description", "name", "readme"]
          like [
            {
              "_index" => "projects",
              "_type" => "repository",
              "_id" => id
            }
          ]
        end
      end
    end
  end
end
