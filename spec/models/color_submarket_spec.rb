require 'rails_helper'

describe ColorSubmarket do
  describe '#create' do
     it { should validate_presence_of(:price) }
    it do
      should validate_inclusion_of(:default).
      in_array([true, false])
    end
  end

  describe 'associations' do
     it { should belong_to(:color) }
     it { should belong_to(:submarket) }
  end
end
