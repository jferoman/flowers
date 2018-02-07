require 'rails_helper'

describe Production do

  describe '#create' do

    it { should validate_presence_of(:quantity) }
    it { should validate_presence_of(:origin) }

    it { should have_db_index( [:variety_id, :cutting_id, :week_id, :origin] ).unique(true) }

  end

  describe 'associations' do
    it { should belong_to(:variety) }
    it { should belong_to(:week) }
    it { should belong_to(:cutting) }
  end

end
