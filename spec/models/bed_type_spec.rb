require 'rails_helper'

describe BedType do
  describe '#create' do

    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:width) }

    it { should have_db_index( [:name, :width] ).unique(true) }

  end

  describe 'associations' do
    it { should have_many(:beds) }
    it { should have_many(:model_sowing_solutions) }

  end
end
