require 'rails_helper'

RSpec.describe ResultSet do
  context "first page" do
    let(:results) do
      ResultSet.new(
        results: [:a, :b, :c],
        total: 10,
        pagination: Pagination.new(3, 0)
      )
    end

    it "has a next page" do
      expect(results.has_next_page?).to be_truthy
      expect(results.next_page).to eq 3
    end

    it "doesn't have a previous page" do
      expect(results.has_previous_page?).to be_falsey
    end
  end

  context "second page" do
    let(:results) do
      ResultSet.new(
        results: [:d, :e, :f],
        total: 10,
        pagination: Pagination.new(3, 3)
      )
    end

    it "has a next page" do
      expect(results.has_next_page?).to be_truthy
      expect(results.next_page).to eq 6
    end

    it "has a previous page" do
      expect(results.has_previous_page?).to be_truthy
      expect(results.previous_page).to eq 0
    end
  end

  context "last page" do
    let(:results) do
      ResultSet.new(
        results: [:j],
        total: 10,
        pagination: Pagination.new(3, 9)
      )
    end

    it "doesn't have a next page" do
      expect(results.has_next_page?).to be_falsey
    end

    it "has a previous page" do
      expect(results.has_previous_page?).to be_truthy
      expect(results.previous_page).to eq 6
    end
  end

  context "after first page" do
    let(:results) do
      ResultSet.new(
        results: [:b, :c, :d],
        total: 10,
        pagination: Pagination.new(3, 1)
      )
    end

    it "has a next page" do
      expect(results.has_next_page?).to be_truthy
      expect(results.next_page).to eq 4
    end

    it "has a previous page" do
      expect(results.has_previous_page?).to be_truthy
      expect(results.previous_page).to eq 0
    end
  end
end
