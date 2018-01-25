class MainReportsController < ApplicationController

  before_action :find_farm, only: [:index, :sowing]

  def index
    @sowing_detail_last_date = @farm.last_sowing_detail
    @production_last_date = @farm.last_bed_production
    @cutting_last_date = @farm.last_cutting
  end

  def sowing
    gon.cutting = []
    gon.sowing = []
    gon.sowing = @farm.sowing_detail_qty_by_date( params["variety_id"], params["block_id"], params["color_id"], origin = "Ejecutado")

    gon.cutting = @farm.cuttings_by_date( params["variety_id"], params["color_id"], origin = "Teorico") unless !params["block_id"].nil?

    #Filters
    @selected_variety ||= params["variety_id"]
    @selected_color  ||= params["color_id"]
    @selected_block  ||= params["block_id"]

    @blocks = @farm.blocks_sowed
  end

  private
  def find_farm
    @farm = Farm.find(session[:farm_id])
  end
end
