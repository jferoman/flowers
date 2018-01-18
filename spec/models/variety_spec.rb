require 'rails_helper'

describe Variety do
  describe '#create' do
    it {should validate_presence_of(:participation)}
    it {should validate_presence_of(:name)}
    it {should validate_inclusion_of(:participation).in_range(0.0..1.0)}

    it { should have_db_index( [:name, :flower_id] ).unique(true) }
  end

  describe 'associations' do
  	it { should belong_to(:storage_resistance_type) }
  	it { should belong_to(:flower) }
  	it { should belong_to(:color) }

    it { should have_many(:productivity_curves) }
    it { should have_many(:cuttings) }
    it { should have_many(:sowing_details) }
    it { should have_many(:sowing_solutions) }
    it { should have_many(:block_productions) }
    it { should have_many(:bed_productions) }
  end
end
