require 'rails_helper'

describe BedProduction do
   describe '#create' do

    it { should validate_presence_of(:quantity) }
    it { should validate_presence_of(:status) }

    it { should have_db_index( [:variety_id, :bed_id, :week_id, :status] ).unique(true) }

  end

  describe 'associations' do
    it { should belong_to(:variety) }
    it { should belong_to(:bed) }
    it { should belong_to(:week) }
  end
end
