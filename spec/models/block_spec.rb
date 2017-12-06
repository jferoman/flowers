require 'rails_helper'

describe Block do
  describe '#create' do
    #it { should validate_uniqueness_of(:name) }
    it { should validate_presence_of(:name) }
  end

  describe 'associations' do
    it { should belong_to(:farm) }
    it { should have_many(:beds) }
  end
end
