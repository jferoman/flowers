require 'rails_helper'

describe Farm do

  describe '#create' do
    let!(:company) { create :company }
    let!(:farm) { create :farm , company: company }

    it { should validate_uniqueness_of(:code) }
    it { should validate_presence_of(:code) }
    it { should validate_presence_of(:company_id) }
    it { should validate_length_of(:code).is_at_least(2).on(:create) }
  end

  describe 'associations' do
    it { should belong_to(:company) }
    it { should have_many(:blocks) }
    it { should have_many(:productivity_curves) }
    it { should have_many(:flower_densities) }
    it { should have_many(:productions) }

  end

end
