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
		it {should have_many(:block_productions)}
		it {should have_many(:bed_productions)}
    it {should have_many(:sowing_solutions)}
    it {should have_many(:productions)}


	end

	describe 'class methods' do
    describe '#import_file' do
      let!(:weeks_csv_path) { 'db/seeds_data/weeks.csv' }
      it 'creates weeks from provided file' do
        expect{ described_class.import weeks_csv_path }.to_not raise_error
      end
    end
  end

  describe 'Return week X weeks ahead' do
    let!(:week) { create :week , :first_week_2018 }
    let!(:second_week) { create :week , :second_week_2018 }
    let!(:week_24) { create :week , :week_24_2018 }

    it 'Return the next week' do
      expect{ week.next_week_in(1) } == (Week.find_by(initial_day: Date.parse("2018-01-08"), week: 2))
      expect{ week.next_week_in(24) } == (Week.find_by(initial_day: Date.parse("2018-06-13"), week: 25))
    end
  end

end
