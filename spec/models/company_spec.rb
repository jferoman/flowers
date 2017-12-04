require 'rails_helper'

describe Company do

  describe '#create' do
    it { should validate_uniqueness_of(:name) }
    it { should validate_uniqueness_of(:nit) }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:nit) }
  end

  describe 'associations' do
    it { should have_many(:farms) }
  end

end
