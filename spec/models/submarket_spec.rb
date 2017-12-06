require 'rails_helper'

describe Submarket do
  describe '#create' do 
  	let!(:submarket) {create :submarket}
    it { should validate_presence_of(:name)}
    it { should validate_presence_of(:code)}
    it { should validate_uniqueness_of(:name)}
    it { should validate_uniqueness_of(:code)}
  end

  describe 'associations' do 
    it { should have_many(:color_submarkets)}
    it { should have_many(:submarket_weeks)}
    it { should belong_to(:market)}
  end
end
