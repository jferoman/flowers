require 'rails_helper'

describe BlockColorFlower do
  describe '#create' do
    it { should have_db_index( [:block_id, :flower_id, :color_id] ).unique(true) }

  end

  describe 'associations' do
    it { should belong_to(:block) }
    it { should belong_to(:flower) }
    it { should belong_to(:color) }
  end
end
