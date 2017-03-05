require 'rails_helper'

RSpec.describe Searcher do
  it "generates different results each time" do
    searcher = Searcher.new
    first_result = searcher.random
    second_result = searcher.random

    expect(first_result.total).to eq(second_result.total)
    expect(first_result).not_to eq(second_result)
  end
end
