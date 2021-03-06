class ColorSubmarketsController < ApplicationController

  before_action :authorize, :lock_farms_per_company
  before_action :find_color_submarket, only: [:destroy, :edit, :update]
  before_action :find_company, only: [:index, :new, :edit, :batch_delete]

  def index
    @color_submarkets = @company.color_submarkets
    @submarkets = Submarket.where(id: @color_submarkets.pluck(:submarket_id).uniq)
  end

  def new
    @color_submarket = ColorSubmarket.new
  end

  def create
    @new_color_submarket = ColorSubmarket.new(color_submarket_params)

    if @new_color_submarket.save
      flash[:success] = 'Registro creado'
      redirect_to color_submarkets_path
    else
      flash[:error] = @new_color_submarket.errors.full_messages.to_sentence
      redirect_to :new_color_submarket
    end
  end

  def destroy
    if @color_submarket.destroy
      flash[:success] = 'Registro eliminado.'
      redirect_to color_submarkets_path
    else
      flash[:error] = @color_submarket.errors.full_messages.to_sentence
      redirect_to color_submarkets_path
    end
  end

  def edit
  end

  def update
    @color_submarket.attributes = color_submarket_params
    if @color_submarket.save
      flash[:success] = 'Registro actualizado'
      redirect_to color_submarkets_path
    else
      flash[:error] = @color_submarket.errors.full_messages.to_sentence
      redirect_to color_submarkets_path
    end
  end

  def import
    begin
      file_path = ColorSubmarket.import(params[:file].path)
    rescue Exception => e
      p e
    end
    if file_path.is_a? String
      redirect_to color_submarkets_path, alert: "El archivo cargado contiene errores."
      send_file file_path
    else
      redirect_to color_submarkets_path, notice: "Archivo importado corretamente"
    end
  end

  def batch_delete
    if params[:submarket_id] == "all"
      ColorSubmarket.where(id: @company.color_submarkets.pluck(:id) ).delete_all
      notice = "Todas los precios y defectos fueron borradas."
    else
      ColorSubmarket.where(submarket_id: params[:submarket_id]).delete_all
      notice = "Los precios y defectos del submercado: " + Submarket.find(params[:submarket_id]).name + " fueron borradas."
    end
      redirect_to color_submarkets_path, notice: notice
  end

  private
  def color_submarket_params
    params.require(:color_submarket).permit(:price, :default, :submarket_id, :color_id)
  end

  def find_color_submarket
    @color_submarket = ColorSubmarket.find(params[:id])
  end

  def find_company
    @company = Company.find(session[:company_id])
  end
end
