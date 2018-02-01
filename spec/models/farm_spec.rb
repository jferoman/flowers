require 'rails_helper'

describe Farm do

  describe '#create' do
    let!(:company) { create :company }
    let!(:farm) { create :farm , company: company }

    it { should validate_uniqueness_of(:code) }
    it { should validate_uniqueness_of(:name) }
    it { should validate_presence_of(:code) }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:company_id) }
    it { should validate_length_of(:code).is_at_least(2).on(:create) }
  end

  describe 'associations' do
    it { should belong_to(:company) }
    it { should have_many(:blocks) }
    it { should have_many(:productivity_curves) }
    it { should have_many(:flower_densities) }
    it { should have_many(:cuttings) }
    it { should have_many(:coldrooms) }
    it { should have_many(:block_productions) }
    it { should have_many(:bed_productions) }
    it { should have_many(:productions) }

    it { should have_many(:beds) }
    it { should have_many(:block_color_flowers) }
    it { should have_many(:sowing_details) }
    it { should have_many(:sowing_solutions) }

  end

  describe 'methods' do

    it 'Sowing details by date' do
      seed
      sowing = Farm.first.sowing_detail_qty_by_date( "", "", "",  "Ejecutado")
      expect( sowing["1 - 2018"] ).to eq(100)

      cutting = Farm.first.cuttings_by_date("", "", "Teorico")
      expect( cutting["1 - 2018"] ).to eq(200)

      expect(Farm.first.blocks_sowed.first).to eq(Block.first)
    end

  end

  describe 'Generate cuttings and production' do
    it 'Generate cuttings' do
      seed
      # Execute method for test.
      Farm.first.generate_cuttings("Modelo")

      expect( Cutting.where(origin: "Modelo").count ).to eq(1)
      expect( Cutting.first.quantity ).to eq(200)

      Farm.first.generate_cuttings("Ejecutado")

      expect( Cutting.where(origin: "Ejecutado").count ).to eq(1)
      # expect( Cutting.first.quantity ).to eq(200)
    end

    it 'Generate bed productions' do
      seed
      Farm.first.generate_bed_production

      expect( BedProduction.all.count ).to eq(1)

      expect( BedProduction.first.quantity ).to eq(SowingDetail.first.quantity*ProductivityCurve.first.production)

    end

    it 'Generate bed productions' do
      seed
      Farm.first.generate_block_production

      expect( BlockProduction.all.count ).to eq(1)
      expect( BlockProduction.first.quantity ).to eq(SowingSolution.first.quantity*ProductivityCurve.first.production)

    end
  end

  def seed
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

      esquejes_1 = Cutting.create!(quantity: 200, cutting_week: 105, origin: "Teorico", farm_id: la_gaitana.id, week_id: jan_1_2018.id, variety_id: 1)
      curva_prod_v1 = ProductivityCurve.create!(week_number: 1, cost: 0.5, production: 0.5, cut: 1, farm_id: la_gaitana.id, variety_id: variedad_1.id)

      siembra_1 = SowingDetail.create!(quantity: 100,
                                       cutting_week: 1,
                                       origin: "Ejecutado",
                                       variety_id: variedad_1.id,
                                       bed_id: cama_1.id,
                                       week_id: jan_1_2018.id,
                                       expiration_week_id: jan_1_2018.next_week_in(1).id)


      solucion_siembra_1 = SowingSolution.create!(quantity: 100,
                                                 cutting_week: 1,
                                                 variety_id: variedad_1.id,
                                                 week_id: jan_1_2018.id,
                                                 block_id: bloque_1.id,
                                                 bed_type_id: tipo_angosta.id,
                                                 expiration_week_id: jan_1_2018.next_week_in(1).id)

  end

end
