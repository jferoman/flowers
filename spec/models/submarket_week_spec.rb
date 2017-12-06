require 'rails_helper'

describe SubmarketWeek do
  describe '#create' do 
	it {should validate_presence_of(:week_id)}
	it {should validate_presence_of(:submarket_id)}
	it { should have_db_index( [:week_id, :submarket_id] ).unique(true) }
  end

  describe 'associations' do 
    it { should belong_to(:week) }
    it { should belong_to(:submarket)}
  end
end
