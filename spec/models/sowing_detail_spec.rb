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

  describe 'generate cuttings' do

    let!(:variety) { create :variety, :with_color_flower}
    let!(:week) { create :week , :first_week_2018 }
    let!(:bed) { create :bed }
    let!(:sowing_detail) { create :sowing_detail, variety: variety, week: week ,bed: bed, expiration_week_id: 1}

    it 'Generate cuttings' do
      # binding.pry
      # expect( ).to be true
    end

  end

end
