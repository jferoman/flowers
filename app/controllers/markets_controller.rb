class MarketsController < ApplicationController

  before_action :authorize, :lock_farms_per_company
  before_action :find_market, only: [:destroy, :edit, :update]
  before_action :find_company, only: [:index, :create]

  def index
    @markets = @company.markets
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
  def market_params
    params.require(:market).permit(:name, :code, :company_id)
  end

  def find_company
    @company = Company.find(session[:company_id])
  end

  def index_route
    "/farms/" + session[:farm_id].to_s + "/markets"
  end

  def find_market
    @market = Market.find(params[:id])
  end
end
