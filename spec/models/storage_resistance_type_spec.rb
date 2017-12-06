require 'rails_helper'

describe StorageResistanceType do
  describe '#create' do

    let!(:storage_resistance_type) { create :storage_resistance_type }

    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }

  end

  describe 'associations' do
    it { should have_many(:storage_resistance) }
    it { should have_many(:variety) }
  end
end
