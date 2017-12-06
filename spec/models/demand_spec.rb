require 'rails_helper'

describe Demand  do
  describe '#create' do 
    it {should validate_presence_of(:color_id)}
    it {should validate_presence_of(:flower_id)}
    it {should validate_presence_of(:market_id)}
    it {should validate_presence_of(:week_id)}
    it {should validate_numericality_of(:quantity).is_greater_than(0)}
  end

  describe 'associations' do 
  	it { should belong_to(:color) }
  	it { should belong_to(:flower) }
  	it { should belong_to(:market) }
  	it { should belong_to(:week) }
  end	
end
