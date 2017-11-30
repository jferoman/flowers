require 'rails_helper'

describe Bed do
  describe '#create' do
    it { should validate_uniqueness_of(:number) }
    it { should validate_presence_of(:number) }
    it { should validate_presence_of(:area) }
    it { should validate_presence_of(:type) }
    it { should validate_presence_of(:capacity) }
    it { should validate_numericality_of(:area).is_greater_than(0.0) }
    it { should validate_numericality_of(:capacity).is_greater_than(0) }
  end

  describe 'associations' do
    it { should belong_to(:block) }
  end
end
