require 'rails_helper'

describe Block do
  describe '#create' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:farm_id) }
    it { should have_db_index( [:name, :farm_id] ).unique(true) }

  end

  describe 'associations' do
    it { should belong_to(:farm) }
    it { should have_many(:beds) }
    it { should have_many(:block_color_flowers) }
    it { should have_many(:sowing_solutions) }
    it { should have_many(:productions) }
  end

  describe 'class methods' do
    describe '#import_file' do
      let!(:blocks_csv_path) { 'spec/files/bloques1.csv' }
      it 'creates blocks from provided file' do
        expect{ described_class.import blocks_csv_path }.to_not raise_error
      end
    end

    describe '#import_file' do
      let!(:blocks_csv_path) { 'spec/files/bloques2.csv' }
      it 'not creates blocks from provided file' do
        described_class.import blocks_csv_path
        expect( Block.count).to be( 0  )
      end
    end
  end
end
