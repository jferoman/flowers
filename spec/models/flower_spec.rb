require 'rails_helper'

describe Flower do
   describe '#create' do
    it { should validate_uniqueness_of(:type) }
    it { should validate_presence_of(:type) }
  end

  describe 'associations' do
    it { should have_many(:historical_kilometers) }
    it { should have_many(:interventions).through(:buses_interventions) }

    it { should belong_to(:body_work) }

    it { should have_one(:company) }
  end
end
