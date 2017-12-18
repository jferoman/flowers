require 'rails_helper'

describe Week do
	describe '#create' do
		it  {should validate_presence_of(:initial_day)}
		it  {should validate_presence_of(:week)}
		it { should have_db_index( [:initial_day, :week] ).unique(true) }
	end
	describe 'associations' do
		it {should have_many(:submarket_weeks)}
		it {should have_many(:cuttings)}
		it {should have_many(:demands)}
		it {should have_many(:sowing_details)}
		it {should have_many(:productions)}
		it {should have_many(:bed_productions)}
	end

	describe 'class methods' do
    describe '#import_file' do
      let!(:weeks_csv_path) { 'db/seeds_data/weeks.csv' }
      it 'creates weeks from provided file' do
        expect{ described_class.import weeks_csv_path }.to_not raise_error
      end
    end
  end

end
