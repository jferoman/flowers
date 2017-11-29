require 'rails_helper'

describe ReferenceFleetHelper, type: :module do
  describe '#calculate_participation' do
    let(:args) do
      {
        buses_art: 384,
        buses_biart: 68,
        km_com_art: 301621188,
        km_com_biart: 66575748,
        reference_fleets: {},
        headers: [:flotaRefA,:flotaRefB],
        array: [["j1",137,10], ["j2",223,0], ["j3",178,0], ["j4",134,0], ["j5",165,0], ["j6",205,0], ["j7",157,0], ["j8",35,82], ["j9",44,130], ["j10",32,78]]
      }
    end

    it 'returns a hash' do
      expect(described_class.calculate_participation args).to be_a Hash
    end
  end
end
