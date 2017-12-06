require 'rails_helper'

describe Flower do
	describe '#create' do 
		let!(:flower) { create :flower }
		it {should validate_presence_of(:name)}
		it {should validate_uniqueness_of(:name) }
	end

	describe 'associations' do 
		it { should have_many(:flower_densities) }
		it { should have_many(:demands) }
		it { should have_many(:varieties) }
		it { should have_many(:block_color_flowers) }
	end
end
