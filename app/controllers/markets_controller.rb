class MarketsController < ApplicationController

  before_action :authorize, :lock_farms_per_company
  before_action :find_market, only: [:destroy, :edit, :update]
  before_action :find_company, only: [:index, :create]

  def index
    @markets = @company.markets
  end

  def new
    @market = Market.new
  end

  def create
    @new_market = @company.markets.new(market_params)

    if @new_market.save
      flash[:success] = 'Mercado creado'
      redirect_to index_route
    else
      flash[:error] = @new_market.errors.full_messages.to_sentence
      redirect_to :new_market
    end
  end

  def destroy
    if @market.destroy
      flash[:success] = 'Mercado eliminado'
      redirect_to index_route
    else
      flash[:error] = @market.errors.full_messages.to_sentence
      redirect_to index_route
    end
  end

  def edit
  end

  def update
    @market.attributes = market_params
    if @market.save
      flash[:success] = 'Mercado actualizado'
      redirect_to index_route
    else
      flash[:error] = @market.errors.full_messages.to_sentence
      redirect_to index_route
    end
  end

  private
  def market_params
    params.require(:market).permit(:name, :code, :company_id)
  end

  def find_company
    @company = Company.find(session[:company_id])
  end

  def index_route
    "/company/" + session[:company_id].to_s + "/markets"
  end

  def find_market
    @market = Market.find(params[:id])
  end
end
