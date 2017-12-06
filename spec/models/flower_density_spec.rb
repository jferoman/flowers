require 'rails_helper'

describe FlowerDensity do
  describe '#create' do

    it { should validate_presence_of(:density) }
    it { should validate_presence_of(:farm_id) }
    it { should validate_presence_of(:flower_id) }

    it { should validate_numericality_of(:density).is_greater_than(0.0) }

    it { should have_db_index( [:farm_id, :flower_id] ).unique(true) }

  end

  describe 'associations' do
    it { should belong_to(:farm) }
    it { should belong_to(:flower) }
  end
end
