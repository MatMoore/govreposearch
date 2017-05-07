namespace :crawler do
  desc "Crawl github repositories and index them"
  task crawl: :environment do
    index = Index.new
    organisations = OrganisationLoader.organisations
    crawler = Crawler.new

    start_org = ENV['START']
    started = start_org.nil?

    organisations.each do |organisation|
      if organisation.github_name == start_org
        started = true
      elsif !started
        next
      end

      begin
        repositories = crawler.repositories_for_organisation(organisation)
      rescue Crawler::TryAgainError => e
        sleep(e.delay_in_seconds)
        redo
      end

      next unless repositories.present?

      response = index.bulk_upsert(repositories)

      if response[:errors]
        Rails.logger.error("Failed to index #{organisation}")
        sleep(1)
        redo
      end
    end

    puts "Repositories without licences:"
    puts crawler.no_licence
    puts "Total with no licence: #{crawler.no_licence.size}"
    puts "Total seen: #{crawler.number_seen}"
    puts "Total indexed: #{crawler.number_valid}"
  end
end
