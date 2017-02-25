namespace :crawler do
  desc "Crawl github repositories"
  task crawl: :environment do
    Crawler.new.each do |repo|
      puts repo
    end
  end
end
