require 'csv'

namespace :search do
  desc "Evaluate search results against example queries"
  task evaluate: :environment do
    JUDGEMENTS_FILE = Rails.root.join('data', 'judgements.csv')

    judgements = CSV.read(JUDGEMENTS_FILE, headers: :first_row)
    searcher = Searcher.new(log: false)

    total_score = 0

    judgements.each do |row|
      query = row['query']
      better_choice = row['better_choice']
      worse_choice = row['worse_choice']
      results = searcher.search(query).to_a
      better_choice_idx = results.index {|result| result.organisation + "/" + result.name == better_choice}
      worse_choice_idx = results.index {|result| result.organisation + "/" + result.name == worse_choice}
      score = 0

      unless better_choice_idx.nil?
        score += 1.0 / (better_choice_idx + 1)
      end

      unless worse_choice_idx.nil?
        score -= 1.0 / (worse_choice_idx + 1)
      end

      if score < 0
        score = 0
      end

      puts "#{query}: #{'%.2f' % score}"

      total_score += score
    end

    total_score = total_score / judgements.size.to_f * 100

    puts "-" * 70
    puts "Score: #{'%.0f' % total_score}%"
    puts "-" * 70
  end
end
