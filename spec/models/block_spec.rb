require 'rails_helper'

describe Block do
  describe '#create' do
    it { should validate_uniqueness_of(:name) }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:area) }
    it { should validate_numericality_of(:area).is_greater_than(0.0) }
  end

  describe 'associations' do
    it { should belong_to(:land) }
  end
end
