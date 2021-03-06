require 'rails_helper'

describe Company do

  describe '#create' do

    let!(:company) { create :company }
    it { should validate_uniqueness_of(:name) }
    it { should validate_uniqueness_of(:nit) }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:nit) }
  end

  describe 'associations' do
    it { should have_many(:farms) }
    it { should have_many(:markets) }
    it { should have_many(:submarkets) }
    it { should have_many(:color_submarkets) }
    it { should have_many(:blocks) }
  end

end
