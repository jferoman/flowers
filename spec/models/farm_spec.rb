require 'rails_helper'

describe Farm do

  describe '#create' do
    # it { should validate_uniqueness_of(:code) }
    it { should validate_presence_of(:code) }
    it { should validate_length_of(:code).is_at_least(2).on(:create) }
  end

  describe 'associations' do
    it { should belong_to(:company) }
    it { should have_many(:blocks) }
  end

end
