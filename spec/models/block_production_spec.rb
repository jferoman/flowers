require 'rails_helper'

describe BlockProduction do
  describe '#create' do

    it { should validate_presence_of(:quantity) }

    it { should have_db_index( [:variety_id, :farm_id, :week_id, :block_id, :status] ).unique(true) }

  end

  describe 'associations' do
    it { should belong_to(:variety) }
    it { should belong_to(:farm) }
    it { should belong_to(:week) }
    it { should belong_to(:block) }

  end
end
