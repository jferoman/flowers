require 'rails_helper'

describe Market do
	describe '#create' do
		let!(:company) {create :company}
		let!(:markerts) {create :market, company_id: company.id}
		it { should validate_presence_of(:name)}
		it { should validate_presence_of(:code)}
		it { should validate_presence_of(:name)}
	end
	describe 'assosiations' do
		it { should have_many(:demands)}
		it { should have_many(:submarkets)}
		it { should belong_to(:company)}
    it { should have_many(:color_submarkets) }

	end
end
