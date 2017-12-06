require 'rails_helper'

describe StorageResistance do
  describe '#create' do

    it { should validate_presence_of(:week_number) }
    it { should validate_presence_of(:storage_resistance_type_id) }
    it { should validate_presence_of(:lost_percentage) }

    it { should validate_inclusion_of(:lost_percentage).in_range(0.0..1.0) }
  end

  describe 'associations' do
    it { should belong_to(:storage_resistance_type) }
  end
end
