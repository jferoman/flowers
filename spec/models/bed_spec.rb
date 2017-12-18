require 'rails_helper'

describe Bed do
  describe '#create' do

    it { should validate_presence_of(:number) }
    it { should validate_presence_of(:total_area) }
    it { should validate_presence_of(:usable_area) }
    it { should validate_presence_of(:block_id) }
    it { should validate_presence_of(:bed_type_id) }

    it { should validate_numericality_of(:total_area).is_greater_than(0.0) }
    it { should validate_numericality_of(:usable_area).is_greater_than(0.0) }

    it { should have_db_index( [:number, :block_id] ).unique(true) }

  end

  describe 'associations' do
    it { should belong_to(:block) }
    it { should belong_to(:bed_type) }
    it { should have_many(:sowing_details) }
    it { should have_many(:bed_productions) }
  end

  describe 'class methods' do
    describe '#import_file' do
      let!(:beds_csv_path) { 'db/seeds_data/beds.csv' }
      it 'creates beds from provided file' do
        expect{ described_class.import beds_csv_path }.to_not raise_error
      end
    end

    # describe '#import_file' do
    #   let!(:beds_csv_path) { 'spec/files/bloques2.csv' }
    #   it 'not creates blocks from provided file' do
    #     described_class.import beds_csv_path
    #     expect( Block.count).to be( 0  )
    #   end
    # end
  end

end
