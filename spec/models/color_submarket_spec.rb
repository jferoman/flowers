require 'rails_helper'

describe ColorSubmarket do
  describe '#create' do 
     it { should validate_presence_of(:price) }
     it { should validate_presence_of(:price) }
  end

  describe 'associations' do 
     it { should belong_to(:color) }
     it { should belong_to(:submarket) }
  end
end
