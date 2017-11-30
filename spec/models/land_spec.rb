require 'rails_helper'

describe Land do
  describe '#create' do
    it { should validate_uniqueness_of(:code) }
    it { should validate_presence_of(:code) }
    it { should validate_presence_of(:total_area) }
    it { should validate_length_of(:code).is_at_least(2).on(:create) }
    it { should validate_numericality_of(:total_area).is_greater_than(0.0) }
  end

  describe 'associations' do
    it { should belong_to(:company) }
    it { should have_many(:blocks) }
  end

  describe 'get blocks area' do
    let!(:land) { create :land }

    it 'sum the blocks area' do
      binding.pry
      expect ().to be()
    end
  end

end
