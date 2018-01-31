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
  def generate_block_production_cutting origin = "Teorico"
    block_productions = []
    cuttings.where(origin: origin).each do |cutting|

      production = 0
      (1..(cutting.cutting_week)).each do |s|

        production += (cutting.quantity * cutting.variety.get_productivity(s))

        next unless (BlockProduction.find_by( quantity: production,
                                              origin: origin,
                                              variety_id: cutting.variety_id,
                                              farm_id: id,
                                              week_id: cutting.week.next_week_in(s).id,
                                              block_id: cutting.block.id))

        block_productions << {
          quantity: production,
          origin: origin,
          variety_id: cutting.variety_id,
          farm_id: id,
          week_id: cutting.week.next_week_in(s).id,
          block_id: cutting.block.id
        }

      end
    end
    BlockProduction.bulk_insert values: block_productions
  end
  ##
  # Retorna la fecha del ultimo plano de siembra ejecutado para la finca
  ##
  def last_sowing_detail
    Week.where(id: sowing_details.where(origin: "Ejecutado").pluck(:week_id)).order(:initial_day).last.initial_day rescue "-"
  end

  ##
  # Retorna la fecha del primer plano de siembra ejecutado para la finca
  ##
  def first_sowing_detail
    Week.where(id: sowing_details.where(origin: "Ejecutado").pluck(:week_id)).order(:initial_day).first.initial_day
  end

  ##
  # Retorna la fecha de la última producción ejecutado para la finca
  ##
  def last_bed_production
    Week.where(id: bed_productions.where(origin: "Ejecutado").pluck(:week_id)).order(:initial_day).last.initial_day rescue "-"
  end

  ##
  # Retorna la fecha del último esqueje ejecutado para la finca
  ##
  def last_cutting
    Week.where(id: cuttings.where(origin: "Ejecutado").pluck(:week_id)).order(:initial_day).last.initial_day rescue "-"
  end

  ##
  # Retorna la primera del último esqueje ejecutado para la finca
  ##
  def first_cutting
    Week.where(id: cuttings.where(origin: "Ejecutado").pluck(:week_id)).order(:initial_day).first.initial_day
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

    sowing_by_variety = sowing_detail_by_variety(variety_id, origin)
    sowing_by_block   = sowing_detail_by_block(block_id, origin)
    sowing_by_color   = sowing_detail_by_color(color_id , origin)

    sowing = sowing.merge(sowing_by_variety) unless sowing_by_variety.empty?
    sowing = sowing.merge(sowing_by_block) unless sowing_by_block.empty?
    sowing = sowing.merge(sowing_by_color) unless sowing_by_color.empty?

    sowing = sowing.group(:week_id).sum(:quantity).transform_keys{ |key| id_week[key] }.sort.to_h

    sowing.each do |date, qty|
      week_year[date_week[date].to_s + " - " + date.year.to_s].nil? ? week_year[date_week[date].to_s + " - " + date.year.to_s] = qty :
                                                                      week_year[date_week[date].to_s + " - " + date.year.to_s] += qty
    end
    week_year
  end

  ##
  # Retorna las siembras de la finca por variedad y origen
  # Parametros: Id de la variedad para las siembras
  #            origen: Por defecto lo hace para los Ejecutados
  # Retorna: planos de siembra para el origen dado y la variedad especificada
  #
  ##
  def sowing_detail_by_variety( variety_id = nil, origin = "Ejecutado")
    sowing_details.where(origin: origin, variety_id: variety_id)
  end

  ##
  # Retorna las siembras de la finca por bloque y origen
  # Parametros: Id del bloque para las siembras
  #             origen: Por defecto lo hace para los Ejecutados
  # Retorna: planos de siembra para el origen dado y el bloque especificada
  #
  ##
  def sowing_detail_by_block( block_id = nil, origin = "Ejecutado")
    sowing_details.where(origin: origin).joins(:bed).where(:beds => {block_id: block_id})
  end

  ##
  # Retorna las siembras de la finca por color y origen
  # Parametros: Id del color para las siembras
  #             origen: Por defecto lo hace para los Ejecutados
  # Retorna: planos de siembra para el origen dado y el color especificado
  #
  ##
  def sowing_detail_by_color( color_id = nil, origin = "Ejecutado")
    sowing_details.where(origin: origin).joins(:variety).where(:varieties => {color_id: color_id})
  end

  ##
  # Retorna la cantidad de esquejes por fecha.
  # Parametros: origen: Por defecto lo hace para los Ejecutados
  # Retorna: Hash con la fecha y la cantidad de siembras.
  ##
  def cuttings_by_date (variety_id = nil, block_id = nil, color_id = nil, origin = "Teorico")
    date_week = Week.all.pluck(:initial_day, :week).to_h
    id_week = Week.all.pluck(:id, :initial_day).to_h

    week_year = {}

    sel_cuttings = cuttings.where(origin: origin)

    cuttings_by_variety = cuttings_by_variety(variety_id, origin)
    cuttings_by_color   = cuttings_by_color(color_id , origin)

    sel_cuttings = sel_cuttings.merge(cuttings_by_variety) unless cuttings_by_variety.empty?
    sel_cuttings = sel_cuttings.merge(cuttings_by_color) unless cuttings_by_color.empty?

    sel_cuttings = sel_cuttings.group(:week_id).sum(:quantity).transform_keys{ |key| id_week[key] }.sort.to_h

    sel_cuttings.each do |date, qty|
      week_year[date_week[date].to_s + " - " + date.year.to_s].nil? ? week_year[date_week[date].to_s + " - " + date.year.to_s] = qty :
                                                                      week_year[date_week[date].to_s + " - " + date.year.to_s] += qty
    end
    week_year

  end

  ##
  # Retorna los esquejes de la finca por variedad y origen
  # Parametros: Id de la variedad para los esquejes
  #            origen: Por defecto lo hace para los Ejecutados
  # Retorna: planos de siembra para el origen dado y la variedad especificada
  #
  ##
  def cuttings_by_variety( variety_id = nil, origin = "Teorico")
    cuttings.where(origin: origin, variety_id: variety_id)
  end

  ##
  # Retorna los esquejes de la finca por color y origen
  # Parametros: Id del color para los esquejes
  #             origen: Por defecto lo hace para los Teoricos
  # Retorna: planos de siembra para el origen dado y el color especificado
  #
  ##
  def cuttings_by_color( color_id = nil, origin = "Teorico")
    cuttings.where(origin: origin).joins(:variety).where(:varieties => {color_id: color_id})
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

    production_by_variety = bed_productions_by_variety(variety_id, origin)
    production_by_color   = bed_productions_by_color(color_id , origin)
    production_by_block   = bed_productions_by_block(block_id, origin)


    sel_production = sel_production.merge(production_by_variety) unless production_by_variety.empty?
    sel_production = sel_production.merge(production_by_block) unless production_by_block.empty?
    sel_production = sel_production.merge(production_by_color) unless production_by_color.empty?

    sel_production = sel_production.group(:week_id).sum(:quantity).transform_keys{ |key| id_week[key] }.sort.to_h

    sel_production.each do |date, qty|
      week_year[date_week[date].to_s + " - " + date.year.to_s].nil? ? week_year[date_week[date].to_s + " - " + date.year.to_s] = qty :
                                                                      week_year[date_week[date].to_s + " - " + date.year.to_s] += qty
    end
    week_year
  end

  ##
  # Retorna la produccioón de la finca por variedad y origen
  # Parametros: Id de la variedad para la produccioón
  #            origen: Por defecto lo hace para los Ejecutados
  # Retorna: Produccion para el origen dado y la variedad especificada
  #
  ##
  def bed_productions_by_variety( variety_id , origin = "Ejecutado")
    bed_productions.where(origin: origin, variety_id: variety_id)
  end

  ##
  # Retorna los esquejes de la finca por color y origen
  # Parametros: Id del color para los esquejes
  #             origen: Por defecto lo hace para los Teoricos
  # Retorna: planos de siembra para el origen dado y el color especificado
  #
  ##
  def bed_productions_by_color( color_id , origin = "Ejecutado")
    bed_productions.where(origin: origin).joins(:variety).where(:varieties => {color_id: color_id})
  end

  ##
  # Retorna la produccion de la finca por bloque y origen
  # Parametros: Id del bloque para la produccion
  #             origen: Por defecto lo hace para los Ejecutados
  # Retorna: planos de siembra para el origen dado y el bloque especificada
  #
  ##
  def bed_productions_by_block( block_id = nil, origin = "Ejecutado")
    bed_productions.where(origin: origin).joins(:bed).where(:beds => {block_id: block_id})
  end

  ##
  # Retorna la produccion por bloque de la finca dados los filtros
  # Parametros variety_id, block_id, color_id por defecto no los usa a menos que se espefiquen
  #
  ##
  def block_productions_qty_by_week(variety_id = nil, block_id = nil, color_id = nil, origin = "Teorico")
    date_week = Week.all.pluck(:initial_day, :week).to_h
    id_week = Week.all.pluck(:id, :initial_day).to_h

    week_year = {}

    sel_production = block_productions.where(origin: origin)

    production_by_variety = block_productions_by_variety(variety_id, origin)
    production_by_color   = block_productions_by_color(color_id , origin)
    production_by_block   = block_productions_by_block(block_id, origin)


    sel_production = sel_production.merge(production_by_variety) unless production_by_variety.empty?
    sel_production = sel_production.merge(production_by_block) unless production_by_block.empty?
    sel_production = sel_production.merge(production_by_color) unless production_by_color.empty?

    sel_production = sel_production.group(:week_id).sum(:quantity).transform_keys{ |key| id_week[key] }.sort.to_h

    sel_production.each do |date, qty|
      week_year[date_week[date].to_s + " - " + date.year.to_s].nil? ? week_year[date_week[date].to_s + " - " + date.year.to_s] = qty :
                                                                      week_year[date_week[date].to_s + " - " + date.year.to_s] += qty
    end
    week_year
  end

  ##
  # Retorna la produccioón de la finca por variedad y origen
  # Parametros: Id de la variedad para la produccioón
  #            origen: Por defecto lo hace para los Ejecutados
  # Retorna: Produccion para el origen dado y la variedad especificada por bloque
  #
  ##
  def block_productions_by_variety( variety_id , origin = "Teorico")
    block_productions.where(origin: origin, variety_id: variety_id)
  end

  ##
  # Retorna la produccioon por bloque de la finca por color y origen
  # Parametros: Id del color para la produccioon por bloque
  #             origen: Por defecto lo hace para los Teoricos
  # Retorna: Produccion para el origen dado y el color especificado por bloque
  #
  ##
  def block_productions_by_color( color_id , origin = "Teorico")
    block_productions.where(origin: origin).joins(:variety).where(:varieties => {color_id: color_id})
  end

  ##
  # Retorna la produccioón de la finca por bloque y origen
  # Parametros: Id de la bloque para la producción
  #            origen: Por defecto lo hace para los Teoricos
  # Retorna: Produccion para el origen dado y el bloque especificada por bloque
  #
  ##
  def block_productions_by_variety( block_id , origin = "Teorico")
    block_productions.where(origin: origin, block_id: block_id)
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

end
