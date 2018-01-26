class MainReportsController < ApplicationController

  before_action :find_farm, only: [:index]

  def index
    @sowing_detail_last_date = @farm.last_sowing_detail
    @production_last_date = @farm.last_bed_production
    @cutting_last_date = @farm.last_cutting
  end

  private
  def find_farm
    @farm = Farm.find(session[:farm_id])
  end
end
