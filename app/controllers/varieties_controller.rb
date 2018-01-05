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

  def create
     new_variety = StorageResistanceType.new(variety_params)

    if new_variety.save
      flash[:success] = 'variety creado'
      redirect_to varieties_path
    else
      flash[:error] = new_variety.errors.full_messages.to_sentence
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
     params.permit('name','resistance_to_storage_name','flowe_name')
  end
end
