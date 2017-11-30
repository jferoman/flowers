require 'rails_helper'

describe Land do
  describe '#create' do
    it { should validate_uniqueness_of(:code) }
    it { should validate_presence_of(:code) }
    it { should validate_presence_of(:total_area) }
    it { should validate_length_of(:code).is_at_least(2).on(:create) }
  end

  describe 'associations' do
    it { should belong_to(:company) }
  end
end
