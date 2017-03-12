require 'elasticsearch/dsl'

module Query
  extend Elasticsearch::DSL::Search

  def self.similar_to_query(id)
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
