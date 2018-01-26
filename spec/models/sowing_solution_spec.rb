require 'rails_helper'

describe SowingSolution do
  describe '#create' do
    it { should validate_presence_of(:variety_id) }
    it { should validate_presence_of(:block_id) }
    it { should validate_presence_of(:bed_type_id) }
    it { should validate_presence_of(:week_id) }

  end

  describe 'associations' do
    it { should belong_to(:variety) }
    it { should belong_to(:week) }
    it { should belong_to(:block) }
    it { should belong_to(:bed_type) }
  end

  describe 'Generate cuttings and production' do
    it 'Generate cuttings' do
      seed
      # Execute method for test.
      SowingSolution.generate_cuttings(Farm.first.id)

      expect( Cutting.all.count ).to eq(1)
      expect( Cutting.first.quantity ).to eq(100)
    end

    it 'Generate bed productions' do
      seed
      SowingSolution.generate_block_production(Farm.first)

      expect( BlockProduction.all.count ).to eq(1)
      expect( BlockProduction.first.quantity ).to eq(SowingSolution.first.quantity*ProductivityCurve.first.production)

    end
  end

    def seed
    # Generate test Data
      comp = Company.create!(name: "LA GAITANA", nit: 8000000, phone: "1123456789")
      la_gaitana = Farm.create!(code: "LG", name: "LA GAITANA", mamsl: 2600, pluviosity: 0.0, company_id: comp.id)
      ['CLAVEL','MINICLAVEL'].each { |flower| Flower.create(name: flower)}
      ['MEDIO','FUERTE','DEBIL'].each { |strt| StorageResistanceType.create(name: strt) }
      color_1 = Color.create!(name: "Rojo")
      jan_1_2018 = Week.create!(initial_day: Date.parse("2018-01-01"), week: 1, model_week: nil )
      jan_2_2018 = Week.create!(initial_day: Date.parse("2018-01-08"), week: 2, model_week: nil )

      tipo_angosta = BedType.create(name: "ANGOSTA", width: 50)
      tipo_ancha = BedType.create(name: "ANCHA", width: 64)

      bloque_1 = Block.create!(name: "G-01", farm_id: la_gaitana.id)
      cama_1 = Bed.create!(number: "1", total_area: 100.0, usable_area: 90.0, block_id: bloque_1.id, bed_type_id: 1)
      cama_2 = Bed.create!(number: "2", total_area: 100.0, usable_area: 90.0, block_id: bloque_1.id, bed_type_id: 1)

      variedad_1 = Variety.create!(participation: 0.5, name: "Zapote", storage_resistance_type_id: 1, flower_id: Flower.first.id, color_id: color_1.id)
      curva_prod_v1 = ProductivityCurve.create!(week_number: 1, cost: 0.5, production: 0.5, cut: 1, farm_id: la_gaitana.id, variety_id: variedad_1.id)

      solucion_siembra_1 = SowingSolution.create!(quantity: 100,
                                                 cutting_week: 1,
                                                 variety_id: variedad_1.id,
                                                 week_id: jan_1_2018.id,
                                                 block_id: bloque_1.id,
                                                 bed_type_id: tipo_angosta.id,
                                                 expiration_week_id: jan_1_2018.next_week_in(1).id)
  end

end
