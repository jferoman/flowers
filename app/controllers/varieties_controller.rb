class VarietiesController < ApplicationController

  before_action :authorize
  before_action :find_variety, only: [:destroy, :edit, :update]

  def index
    if params[:farm_id].nil?
  	  @varieties = Variety.all
    else
      @farm = Farm.find(params[:farm_id])
      @varieties
    end
  end

  def new
    @variety = Variety.new
  end

  def create
     new_variety = Variety.new(variety_params)

    if new_variety.save
      flash[:success] = 'Variedad creada'
      redirect_to varieties_path
    else
      flash[:error] = new_variety.errors.full_messages.to_sentence
      redirect_to varieties_path
    end
  end

  def destroy
    if @variety.destroy
      flash[:success] = 'Variedad eliminada'
      redirect_to varieties_path
    else
      flash[:error] = @variety.errors.full_messages.to_sentence
      redirect_to varieties_path
    end
  end

  def edit

  end

  def update
    @variety.attributes = variety_params
    if @variety.save
      flash[:success] = 'Variedad actualizada'
      redirect_to varieties_path
    else
      flash[:error] = @variety.errors.full_messages.to_sentence
      redirect_to varieties_path
    end
  end

	def csv_import
		begin
			Variety.import(params[:file].path)
			redirect_to varieties_path, notice: "Variedades importadas corretamente"
		rescue
		  redirect_to varieties_path, alert: "El archivo cargado contiene errores."
		end
	end

  private

  def find_variety
     @variety = Variety.find(params[:id])
  end

  def variety_params
     params.require(:variety).permit(:name, :participation, :storage_resistance_type_id, :flower_id, :color_id)
  end
end
