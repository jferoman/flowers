require 'rails_helper'

describe ProductivityCurve do
  describe '#create' do

    it { should validate_presence_of(:week_number) }
    it { should validate_presence_of(:cost) }
    it { should validate_presence_of(:production) }
    it { should validate_presence_of(:cut) }

    it { should validate_presence_of(:farm_id) }
    it { should validate_presence_of(:variety_id) }

    it { should validate_numericality_of(:cost).is_greater_than(0.0) }
    it { should validate_numericality_of(:production).is_greater_than(0) }
    it { should validate_numericality_of(:cut).is_greater_than(0) }

    it { should have_db_index( [:week_number, :farm_id, :variety_id] ).unique(true) }

  end

  describe 'associations' do
    it { should belong_to(:farm) }
    it { should belong_to(:variety) }
  end
end
