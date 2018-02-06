class SowingsController < ApplicationController
  before_action :find_farm, only: [:index]

  def index
    from = @farm.first_sowing_detail #> Date.parse(1.years.ago.strftime("%F")) ?
          #@farm.first_sowing_detail : Date.parse(1.years.ago.strftime("%F"))

    gon.weeks = Farm.week_year_hash(from, Date.today)
    gon.weeks.delete("52 - 2017")
    #Filters
    @selected_variety = params["variety_id"] ||= ""
    @selected_color   = params["color_id"] ||= ""
    @selected_block   = params["block_id"] ||= ""
    @blocks = @farm.blocks_sowed

    gon.cutting = []
    gon.sowing = []
    gon.fulfillment = []

    gon.sowing = @farm.sowing_detail_qty_by_date( params["variety_id"],
                                                  params["block_id"], params["color_id"],
                                                  origin = "Ejecutado")
    gon.sowing = gon.sowing.keep_if { |k, v| gon.weeks.key? k }

    if params["block_id"].empty?
      gon.cutting = @farm.cuttings_by_date( params["variety_id"],
                                            params["color_id"],
                                            origin = "Teorico")

      gon.cutting = gon.cutting.keep_if { |k, v| gon.weeks.key? k }
      gon.fulfillment = gon.sowing.merge(gon.cutting){ |k, a_value, b_value| (1-((a_value.to_f-b_value.to_f).abs/a_value.to_f))*100 }

    end

  end

  private
  def find_farm
    @farm = Farm.find(session[:farm_id])
  end
end
