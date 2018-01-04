class SubmarketsController < ApplicationController

  before_action :authorize, :lock_farms_per_company
  before_action :find_submarket, only: [:destroy, :edit, :update]
  before_action :find_company, only: [:index, :new]

  def index
    @submarkets = @company.submarkets
  end

  def new
    @submarket = Submarket.new
  end

  def create
    @new_submarket = Submarket.new(submarket_params)

    if @new_submarket.save
      flash[:success] = 'Mercado creado'
      redirect_to submarkets_path
    else
      flash[:error] = @new_submarket.errors.full_messages.to_sentence
      redirect_to :new_submarket
    end
  end

  def destroy
    if @submarket.destroy
      flash[:success] = 'Submercado eliminado.'
      redirect_to submarkets_path
    else
      flash[:error] = @submarket.errors.full_messages.to_sentence
      redirect_to submarkets_path
    end
  end

  def edit
  end

  def update
    @submarket.attributes = submarket_params
    if @submarket.save
      flash[:success] = 'Submercado actualizado'
      redirect_to submarkets_path
    else
      flash[:error] = @submarket.errors.full_messages.to_sentence
      redirect_to submarkets_path
    end
  end

  def import

    begin
      file_path = Submarket.import(params[:file].path)
    rescue Exception => e
      p e
    end

    if file_path.is_a? String
      redirect_to submarkets_path, alert: "El archivo cargado contiene errores."
      send_file file_path
    else
      redirect_to submarkets_path, notice: "Submercados importados corretamente"
    end
  end

  def import_submarket_weeks
    begin
      file_path = Submarket.import_submarket_weeks(params[:file].path)
    rescue Exception => e
      p e
    end

    if file_path.is_a? String
      redirect_to submarkets_path, alert: "El archivo cargado contiene errores."
      send_file file_path
    else
      redirect_to submarkets_path, notice: "Temporadas de submercados importados corretamente"
    end
  end

  private
  def submarket_params
    params.require(:submarket).permit(:name, :code, :market_id)
  end

  def find_submarket
    @submarket = Submarket.find(params[:id])
  end

  def find_company
    @company = Company.find(session[:company_id])
  end

end
