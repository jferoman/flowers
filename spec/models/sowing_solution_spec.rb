require 'rails_helper'

describe SowingSolution do
  describe '#create' do
    it { should validate_presence_of(:bed_number) }
    it { should validate_presence_of(:block_id) }
    it { should validate_presence_of(:bed_type_id) }
    it { should validate_presence_of(:variety_id) }

  end

  describe 'associations' do
    it { should belong_to(:block) }
    it { should belong_to(:bed_type) }
    it { should belong_to(:variety) }
  end
end
