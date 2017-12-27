class DemandsController < ApplicationController

  before_action :authorize, :lock_farms_per_company
  before_action :find_demand, only: [:destroy, :edit, :update]
  before_action :find_company, only: [:index, :new]

  def index
    @demands = @company.demands
  end

  def new
  end

  def create
  end

  def destroy
  end

  def edit
  end

  def update
  end

  private
  def demand_params
    params.require(:demand).permit(:quantity, :color_id, :market_id, :flower_id, :week_id)
  end

  def find_demand
    @demand = Demand.find(params[:id])
  end

  def find_company
    @company = Company.find(session[:company_id])
  end
end
