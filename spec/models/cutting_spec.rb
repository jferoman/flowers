require 'rails_helper'

describe Cutting do
  describe '#create' do
    it { should validate_presence_of(:farm_id)}
    it { should validate_presence_of(:week_id)}
    it { should validate_presence_of(:variety_id)}
    it { should validate_presence_of(:origin)}
    it { should validate_numericality_of(:quantity).is_greater_than(0.0) }
  end

  describe 'associations' do
    it { should belong_to(:farm) }
    it { should belong_to(:week) }
    it { should belong_to(:variety) }
  end
end
