class LandUsesController < ApplicationController
  before_action :find_farm, only: [:index]

  def index

    @blocks = []
    @selected_variety ||= params["variety_id"]
    @selected_color   ||= params["color_id"]
    @selected_block   ||= params["block_id"]

    from = @farm.first_cutting("Teorico") > Date.parse(1.years.ago.strftime("%F")) ?
           @farm.first_cutting("Teorico") : Date.parse(1.years.ago.strftime("%F"))

    gon.weeks = Farm.week_year_hash(from, Date.today+1.years)
    gon.production = []


  end

  private
  def find_farm
    @farm = Farm.find(session[:farm_id])
  end
end
