require 'rails_helper'

describe Coldroom do
  describe '#create' do

    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:capacity) }
    it { should validate_presence_of(:farm_id) }

    it { should validate_numericality_of(:capacity).is_greater_than(0) }

  end

  describe 'associations' do
    it { should belong_to(:farm) }
  end
end
