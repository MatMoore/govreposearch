require 'rails_helper'

RSpec.describe LicenceScraper do
  let(:mit_in_section) do
    <<~README
      # App name

      One paragraph description and purpose.

      ## Licence

      [MIT License](LICENCE)
    README
  end

  let(:empty_section) do
    <<~README
      # App name

      One paragraph description and purpose.

      ## Licence

      ¯\_(ツ)_/¯

      ## Some other section

      BSD MIT GPL
    README
  end

  let(:long_form_gpl) do
    <<~README
      Bla bla bla

      I hereby declare this software to be released under the GNU General Public License version 3.
    README
  end

  let(:missing_context) do
    <<~README
      Something something BSD
    README
  end

  let(:empty) {""}

  it "returns false for empty readmes" do
    result = described_class.scrape_text(empty)
    expect(result).to be_falsey
  end

  it "finds a licence section" do
    result = described_class.scrape_text(mit_in_section)
    expect(result).to be_truthy
  end

  it "doesn't accept stray acronyms" do
    result = described_class.scrape_text(missing_context)
    expect(result).to be_falsey
  end

  it "doesn't care about the contents of the license section" do
    result = described_class.scrape_text(empty_section)
    expect(result).to be_truthy
  end

  it "extracts a wordy form of the licence name" do
    result = described_class.scrape_text(long_form_gpl)
    expect(result).to be_truthy
  end
end
