namespace :index do
  desc "Create the elasticsearch index"
  task create_or_replace: :environment do
    puts "Creating index..."
    Index.new.create_or_replace
  end

end
