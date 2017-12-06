require 'rails_helper'

describe Color do
  describe '#create' do 
  	let!(:color) { create :color}
  	it {should validate_presence_of(:name)}
  	it {should validate_uniqueness_of(:name)}
  end

  describe 'associations' do 
  	it { should have_many(:demands) }
  	it { should have_many(:varieties) }
  	it { should have_many(:block_color_flowers) }
  	it { should have_many(:color_submarkets) }

  end
end
