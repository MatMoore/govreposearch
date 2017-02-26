namespace :crawler do
  desc "Crawl github repositories"
  task crawl: :environment do
    index = Index.new
    crawler = Crawler.new
    crawler.each do |repo|
      index.add(repo)
    end

    puts "Repositories without licences:"
    puts crawler.no_licence
    puts "Total with no licence: #{crawler.no_licence.size}"
    puts "Total seen: #{crawler.number_seen}"
    puts "Total indexed: #{crawler.number_valid}"
  end
end
