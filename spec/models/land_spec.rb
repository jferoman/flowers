require 'rails_helper'

describe Land do
  describe '#create' do
    it { should validate_uniqueness_of(:code) }
    it { should validate_presence_of(:code) }
    it { should validate_presence_of(:total_area) }
    it { should validate_length_of(:code).is_at_least(2).on(:create) }
    it { should validate_numericality_of(:total_area).is_greater_than(0.0) }
  end

  describe 'associations' do
    it { should belong_to(:company) }
    it { should have_many(:blocks) }
  end

  describe 'Adding blocks ' do
    let!(:land) { create :land }
    let!(:block) { create :block , :first_block }
    let!(:third_block) { create :block , :third_block }
    let!(:large_block) { create :block , :large_block }


    it 'add new block' do
      land.add_block(block)
      expect( land.blocks.count ).to be(1)
      expect( block.land ).to eq(land)
    end

    it 'sum the blocks area' do
      land.add_block(block)
      expect( land.get_blocks_area ).to be(block.area)
    end

    it 'get free area of a land' do
      land.add_block(block)
      expect( land.get_free_area ).to be(500.1-100.0)
    end

    it "raise error by area error" do
      expect{land.add_block(large_block)}.to raise_error(RuntimeError)
    end

    it "raise error by not enough area error" do
      land.add_block(third_block)
      expect{ land.add_block(third_block) }.to raise_error(RuntimeError)
    end
  end

end
