require 'rails_helper'

describe ModelSowingSolution do
  describe '#create' do
    it { should validate_presence_of(:bed_number) }
    it { should validate_presence_of(:block_id) }
    it { should validate_presence_of(:bed_type_id) }

  end

  describe 'associations' do
    it { should belong_to(:block) }
    it { should belong_to(:bed_type) }
  end
end
