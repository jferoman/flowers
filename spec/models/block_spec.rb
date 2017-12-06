require 'rails_helper'

describe Block do
  describe '#create' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:farm_id) }
    it { should have_db_index( [:name, :farm_id] ).unique(true) }

  end

  describe 'associations' do
    it { should belong_to(:farm) }
    it { should have_many(:beds) }
    it { should have_many(:block_color_flowers) }
    it { should have_many(:sowing_solutions) }
  end
end
