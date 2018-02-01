class LandUsesController < ApplicationController
  before_action :find_farm, only: [:index]

  def index

    @blocks = []
    @selected_block    = params["block_id"] ||= ""
    @selected_bed_type = params["bed_type_id"] ||= ""

    total_beds = @farm.beds.count.to_f
    gon.fulfillment = {}

    from = @farm.first_sowing_detail > Date.parse(1.years.ago.strftime("%F")) ?
           @farm.first_sowing_detail : Date.parse(1.years.ago.strftime("%F"))

    @blocks = @farm.blocks_sowed

    gon.weeks = Farm.week_year_hash(from, Date.today + 1.years)

    gon.beds_used = @farm.beds_used_by_week(params["block_id"], params["bed_type_id"])
    gon.beds_used = gon.beds_used.keep_if { |k, v| gon.weeks.key? k }

    gon.beds_used.each do |k, value|
      gon.fulfillment[k] = (1-((total_beds-value).abs/total_beds))*100
    end

  end

  private
  def find_farm
    @farm = Farm.find(session[:farm_id])
  end
end
