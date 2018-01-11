class SubmarketWeeksController < ApplicationController

  before_action :authorize, :lock_farms_per_company
  before_action :find_submarket_week, only: [:destroy, :edit, :update]
  before_action :find_company, only: [:index, :new]

  def index
    @submarket_weeks = @company.submarket_weeks
    @submarket_names = Submarket.where(id: @company.submarket_weeks.pluck(:submarket_id).uniq).pluck(:name)

  end

  def new
    @submarket_week = SubmarketWeek.new

  end

  def create
  end

  def destroy
  end

  def edit
  end

  def update
  end

  def import
  end

  private
  def submarket_week_params
    params.require(:submarket_week).permit(:week_id, :submarket_id)
  end

  def find_submarket_week
    @submarket_week = SubmarketWeek.find(params[:id])
  end

  def find_company
    @company = Company.find(session[:company_id])
  end
end
