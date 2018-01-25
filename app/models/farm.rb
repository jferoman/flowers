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
  # Retorna la fecha del ultimo plano de siembra ejecutado para la finca
  ##
  def last_sowing_detail
    Week.where(id: sowing_details.where(origin: "Ejecutado").pluck(:week_id)).order(:initial_day).last.initial_day rescue "-"
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
  # Retorna los esquejes de la finca por bloque y origen
  # Parametros: Id del bloque para los esquejes
  #             origen: Por defecto lo hace para los Teoricos
  # Retorna: planos de siembra para el origen dado y el bloque especificada
  #
  ##
  def cuttings_by_block( block_id = nil, origin = "Teorico")
    #cuttings.where(origin: origin).joins(:bed).where(:beds => {block_id: block_id})
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

end
