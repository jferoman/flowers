class Farm < ApplicationRecord

  validates_uniqueness_of :code, :name
  validates_presence_of   :code, :name, :company_id
  validates_length_of :code, minimum: 2, on: :create

  belongs_to :company
  has_many :blocks
  has_many :productivity_curves
  has_many :flower_densities
  has_many :block_productions
  has_many :cuttings
  has_many :coldrooms

  has_many :beds, through: :blocks
  has_many :block_color_flowers, through: :blocks
  has_many :sowing_details, through: :beds
  has_many :sowing_solutions, through: :blocks
  has_many :bed_productions, through: :beds
  has_many :block_productions, through: :blocks
  has_many :productions, through: :cuttings

  def productivity_curves_varieties
    Variety.where(id: productivity_curves.all.pluck(:variety_id).uniq)
  end


  ##
  # Generate cuttings from sowing details with specified origin, for the actual farm of the user.
  # Parameters: origin,
  # Return: Generate cuttings with the origin, the variety and week of the sowing detail.
  # SowingDetail.generate_cuttings()
  #
  ##
  def generate_cuttings origin = "Ejecutado"
    cuttings = []
    sowing = {}

    case origin
    when "Modelo"
      sowing = sowing_solutions.group(:variety_id, :week_id, :cutting_week).sum(:quantity)
    when "Teorico"

    else
      sowing = sowing_details.where(origin: origin).group(:variety_id, :week_id, :cutting_week).sum(:quantity)
    end

    sowing.each do |sow|

      cuttings << {
        quantity: sow[1],
        origin: origin,
        cutting_week: sow[0][2],
        farm_id: id,
        week_id: sow[0][1],
        variety_id: sow[0][0]
      }
    end
    Cutting.bulk_insert values: cuttings
  end

  ##
  # Generate the production from the sowing detail "Ejecutado"
  # Parameters:
  # => farm: Farm for the sowings solutions
  #
  # Generate the bed production for this sowing.
  ##
  def generate_bed_production
    bed_productions = []

    sowing_details.where(origin: "Ejecutado").each do |sowing_detail|
      production = 0
      (1..(sowing_detail.cutting_week)).each do |s|

        production += (sowing_detail.quantity * sowing_detail.variety.get_productivity(s))

        next unless (BedProduction.find_by(  quantity: production,
                                                origin: "Esperada",
                                                variety_id: sowing_detail.variety_id,
                                                bed_id: sowing_detail.bed.id,
                                                week_id: sowing_detail.week.next_week_in(s).id).nil?)

        bed_productions << {
          quantity: production,
          origin: "Esperada",
          variety_id: sowing_detail.variety_id,
          bed_id: sowing_detail.bed.id,
          week_id: sowing_detail.week.next_week_in(s).id
        }
      end
    end
    BedProduction.bulk_insert values: bed_productions unless bed_productions.empty?
  end

  ##
  # Generate the production from the sowing detail.
  # Parameters:
  #
  # Generate the bed production for this sowing.
  ##
  # TODO
  def generate_block_production
    block_productions = []
    sowing_solutions.each do |sowing_solution|
      production = 0
      (1..(sowing_solution.cutting_week)).each do |s|

        production += (sowing_solution.quantity * sowing_solution.variety.get_productivity(s))

        block_productions << {
          quantity: production,
          origin: "Modelo",
          variety_id: sowing_solution.variety_id,
          farm_id: id,
          week_id: sowing_solution.week.next_week_in(s).id,
          block_id: sowing_solution.block.id
        }

      end
    end
    BlockProduction.bulk_insert values: block_productions
  end

  ##
  # Generate the production from the cuttings.
  # Parameters: origen, default: Teorico
  #
  # Generate the bed production for the cuttings.
  ##
  # TODO
  def generate_production_cutting origin = "Teorico"
    productions = []

    cuttings.where(origin: origin).each do |cutting|

      production = 0
      (1..(cutting.cutting_week)).each do |s|

        production += (cutting.quantity * cutting.variety.get_productivity(s))

        next unless (Production.find_by(quantity: production,
                                        origin: origin,
                                        variety_id: cutting.variety_id,
                                        cutting_id: cutting.id,
                                        week_id: cutting.week.next_week_in(s).id).nil?)

        productions << {
          quantity: production,
          origin: origin,
          cutting_id: cutting.id,
          variety_id: cutting.variety_id,
          week_id: cutting.week.next_week_in(s).id
        }

      end
    end
    Production.bulk_insert values: productions
  end

  ##
  # Retorna la fecha del ultimo plano de siembra ejecutado para la finca
  ##
  def last_sowing_detail
    Week.where(id: sowing_details.where(origin: "Ejecutado")
                                  .pluck(:week_id))
                                  .order(:initial_day)
                                  .last.initial_day rescue "-"
  end

  ##
  # Retorna la fecha del primer plano de siembra ejecutado para la finca
  ##
  def first_sowing_detail
    Week.where(id: sowing_details.where(origin: "Ejecutado")
                                  .pluck(:week_id))
                                  .order(:initial_day)
                                  .first.initial_day
  end

  ##
  # Retorna la fecha de la última producción ejecutado para la finca
  ##
  def last_bed_production
    Week.where(id: bed_productions.where(origin: "Ejecutado")
                                  .pluck(:week_id))
                                  .order(:initial_day)
                                  .last.initial_day rescue "-"
  end

  ##
  # Retorna la fecha del último esqueje ejecutado para la finca
  ##
  def last_cutting
    Week.where(id: cuttings.where(origin: "Ejecutado")
                                  .pluck(:week_id))
                                  .order(:initial_day)
                                  .last.initial_day rescue "-"
  end

  ##
  # Retorna la primera fecha del primer esqueje ejecutado para la finca
  ##
  def first_cutting origin = "Ejecutado"
    Week.where(id: cuttings.where(origin: origin)
                                  .pluck(:week_id))
                                  .order(:initial_day)
                                  .first.initial_day
  end

  ##
  # Retorna la primera fecha del último esqueje ejecutado para la finca
  ##
  def first_bed_production
    Week.where(id: bed_productions.where(origin: "Ejecutado").
                                  pluck(:week_id)).
                                  order(:initial_day).
                                  first.
                                  initial_day
  end

  ##
  # Retorna la cantidad de siembras por fecha
  # Parametros: origen: Por defecto lo hace para los Ejecutados
  # Retorna: Hash con la fecha y la cantidad de siembras.
  ##
  def sowing_detail_qty_by_date( variety_id = nil, block_id = nil, color_id = nil, origin = "Ejecutado")
    date_week = Week.all.pluck(:initial_day, :week).to_h
    id_week = Week.all.pluck(:id, :initial_day).to_h
    week_year = {}

    sowing = sowing_details.where(origin: origin)

    sowing_by_variety = data_by_variety(sowing_details, variety_id, origin)
    sowing_by_block   = data_by_block(sowing_details, block_id, origin)
    sowing_by_color   = data_by_color(sowing_details, color_id , origin)

    sowing = sowing.merge(sowing_by_variety) if !sowing_by_variety.empty? || !variety_id.empty?
    sowing = sowing.merge(sowing_by_color) if !sowing_by_color.empty? || !color_id.empty?
    sowing = sowing.merge(sowing_by_block) unless sowing_by_block.empty?

    sowing = sowing.group(:week_id).sum(:quantity).transform_keys{ |key| id_week[key] }.sort.to_h

    sowing.each do |date, qty|
      week_year[date_week[date].to_s + " - " + date.year.to_s].nil? ? week_year[date_week[date].to_s + " - " + date.year.to_s] = qty :
                                                                      week_year[date_week[date].to_s + " - " + date.year.to_s] += qty
    end
    week_year

  end

  ##
  # Retorna la lista envaida filtrada por variedad y origen
  #
  #
  ##
  def data_by_variety(data, variety_id , origin)
    data.where(origin: origin, variety_id: variety_id)
  end

  ##
  # Retorna la lista envaida filtrada por bloque y origen
  #
  #
  ##
  def data_by_block(data, block_id, origin)
    data.where(origin: origin).joins(:bed).where(:beds => {block_id: block_id})
  end

  ##
  # Retorna la lista envaida filtrada por color y origen
  ##
    def data_by_color(data, color_id , origin)
    data.where(origin: origin).joins(:variety).where(:varieties => {color_id: color_id})
  end

  ##
  # Retorna la cantidad de esquejes por fecha.
  # Parametros: origen: Por defecto lo hace para los Ejecutados
  # Retorna: Hash con la fecha y la cantidad de siembras.
  ##
  def production_by_date (variety_id = nil, block_id = nil, color_id = nil, origin = "Teorico")
    date_week = Week.all.pluck(:initial_day, :week).to_h
    id_week = Week.all.pluck(:id, :initial_day).to_h

    week_year = {}

    sel_cuttings = productions.where(origin: origin)

    cuttings_by_variety = data_by_variety(productions, variety_id, origin)
    cuttings_by_color   = data_by_color(productions, color_id, origin)

    sel_cuttings = sel_cuttings.merge(cuttings_by_variety) if !cuttings_by_variety.empty? || !variety_id.empty?# unless cuttings_by_variety.empty?
    sel_cuttings = sel_cuttings.merge(cuttings_by_color) if !cuttings_by_color.empty? || !color_id.empty?#unless cuttings_by_color.empty?

    sel_cuttings = sel_cuttings.group(:week_id).sum(:quantity).transform_keys{ |key| id_week[key] }.sort.to_h

    sel_cuttings.each do |date, qty|
      week_year[date_week[date].to_s + " - " + date.year.to_s].nil? ? week_year[date_week[date].to_s + " - " + date.year.to_s] = qty :
                                                                      week_year[date_week[date].to_s + " - " + date.year.to_s] += qty
    end
    week_year

  end


  ##
  # Retorna la cantidad de esquejes por fecha.
  # Parametros: origen: Por defecto lo hace para los Ejecutados
  # Retorna: Hash con la fecha y la cantidad de siembras.
  ##
  def cuttings_by_date (variety_id = nil, color_id = nil, origin = "Teorico")

    date_week = Week.all.pluck(:initial_day, :week).to_h
    id_week = Week.all.pluck(:id, :initial_day).to_h

    week_year = {}

    sel_cuttings = cuttings.where(origin: origin)

    cuttings_by_variety = data_by_variety(cuttings, variety_id, origin)
    cuttings_by_color   = data_by_color(cuttings, color_id, origin)

    sel_cuttings = sel_cuttings.merge(cuttings_by_variety) if !cuttings_by_variety.empty? || !variety_id.empty?
    sel_cuttings = sel_cuttings.merge(cuttings_by_color)   if !cuttings_by_color.empty? || !color_id.empty?

    sel_cuttings = sel_cuttings.group(:week_id).sum(:quantity).transform_keys{ |key| id_week[key] }.sort.to_h

    sel_cuttings.each do |date, qty|
      week_year[date_week[date].to_s + " - " + date.year.to_s].nil? ? week_year[date_week[date].to_s + " - " + date.year.to_s] = qty :
                                                                      week_year[date_week[date].to_s + " - " + date.year.to_s] += qty
    end
    week_year
  end
  ##
  # Retorna los bloques de la finca que tienen siembras ejecutadas
  # Parametros: origen: Por defecto lo hace para los Ejecutados
  # Retorna: bloques
  ##
  def blocks_sowed origin = "Ejecutado"
    Block.where(id: beds.where(id: sowing_details.where(origin: origin).pluck(:bed_id)).pluck(:block_id).uniq)
  end

  ##
  # Retorna la produccion por cama de la finca dados los filtros
  # Parametros variety_id, block_id, color_id por defecto no los usa a menos que se espefiquen
  #
  ##
  def bed_productions_qty_by_week(variety_id = nil, block_id = nil, color_id = nil, origin = "Ejecutado")
    date_week = Week.all.pluck(:initial_day, :week).to_h
    id_week = Week.all.pluck(:id, :initial_day).to_h

    week_year = {}

    sel_production = bed_productions.where(origin: origin)
    production_by_variety = data_by_variety(bed_productions, variety_id, origin)
    production_by_color   = data_by_color(bed_productions, color_id, origin)
    production_by_block   = data_by_block(bed_productions, block_id, origin)

    sel_production = sel_production.merge(production_by_variety) if !production_by_variety.empty? || !variety_id.empty?
    sel_production = sel_production.merge(production_by_color) if !production_by_color.empty? || !color_id.empty?
    sel_production = sel_production.merge(production_by_block) if !production_by_block.empty? || !block_id.empty?

    sel_production = sel_production.group(:week_id).sum(:quantity).transform_keys{ |key| id_week[key] }.sort.to_h

    sel_production.each do |date, qty|
      week_year[date_week[date].to_s + " - " + date.year.to_s].nil? ? week_year[date_week[date].to_s + " - " + date.year.to_s] = qty :
                                                                      week_year[date_week[date].to_s + " - " + date.year.to_s] += qty
    end
    week_year
  end

  ##
  # Retrona un hash {"semana - ano" =>0 }
  # Desde el dia de hoy hasta dos anos atras
  #
  ##
  def self.week_year_hash(from, to)
    week_year = {}

    (from..to).each do |date|
      week_year[date.cweek.to_s + " - " + date.year.to_s] = 0
    end
    week_year
  end

  ##
  # Cacula el numero de camas en uso por semana para la finca
  ##
  def beds_used_by_week(block_id, bed_type_id, origin = "Ejecutado")
    week_year = {}
    date_week = Week.all.pluck(:initial_day, :week).to_h
    id_week = Week.all.pluck(:id, :initial_day).to_h

    beds_by_week = sowing_details.where(origin: origin)

    sowing_by_block = data_by_block(sowing_details, block_id, origin)
    sowing_by_bed_type = sowing_by_bed_type(sowing_details, bed_type_id, origin)

    beds_by_week = beds_by_week.merge(sowing_by_block) unless sowing_by_block.empty?
    beds_by_week = beds_by_week.merge(sowing_by_bed_type) if !sowing_by_bed_type.empty? || !bed_type_id.empty?

    beds_by_week = beds_by_week.group(:week_id).count(:bed_id).transform_keys{ |key| id_week[key] }.sort.to_h

    beds_by_week.each do |date, qty|
      week_year[date_week[date].to_s + " - " + date.year.to_s].nil? ? week_year[date_week[date].to_s + " - " + date.year.to_s] = qty :
                                                                      week_year[date_week[date].to_s + " - " + date.year.to_s] += qty
    end
    week_year
  end

  ##
  # Retorna la lista enviada filtrada por tipo de cama y origen
  # sowing_details
  ##
  def sowing_by_bed_type(data, bed_type_id, origin)
    data.where(origin: origin).joins(:bed).where(:beds => {bed_type_id: bed_type_id})
  end

end
