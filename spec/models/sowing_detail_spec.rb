require 'rails_helper'

describe SowingDetail do
  describe '#create' do
    it {should validate_presence_of(:quantity)}
  	it {should validate_presence_of(:cutting_week)}
  	it {should validate_numericality_of(:quantity).is_greater_than(0.0)}
  end
  describe 'associations' do
  	it { should belong_to(:variety)}
  	it { should belong_to(:week)}
  	it { should belong_to(:bed)}
  end
end
