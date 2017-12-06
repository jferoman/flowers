require 'rails_helper'

describe Bed do
  describe '#create' do

    it { should validate_presence_of(:number) }
    it { should validate_presence_of(:total_area) }
    it { should validate_presence_of(:usable_area) }
    it { should validate_presence_of(:block_id) }
    it { should validate_presence_of(:bed_type_id) }

    it { should validate_numericality_of(:total_area).is_greater_than(0.0) }
    it { should validate_numericality_of(:usable_area).is_greater_than(0.0) }

    it { should have_db_index( [:number, :block_id] ).unique(true) }

  end

  describe 'associations' do
    it { should belong_to(:block) }
    it { should belong_to(:bed_type) }
    it { should have_many(:sowing_details) }
  end
end
