class StorageResistancesController < ApplicationController

  before_action :authorize
  before_action :find_storage_resistance, only: [:destroy, :edit, :update]

	def index
		@storage_resistance_types = StorageResistanceType.all
		@storage_resistances = StorageResistance.all
	end

	def new
    @storage_resistance = StorageResistance.new
    @storage_resistance_types = StorageResistanceType.all
    @week_numbers = [1,2,3,4]
	end

	 def create
    new_storage_resistance = StorageResistance.new(storage_resistance_params)

    if new_storage_resistance.save
      flash[:success] = 'Resistencia al guarde fue creada'
      redirect_to storage_resistances_path
    else
      flash[:error] = new_storage_resistance.errors.full_messages.to_sentence
      redirect_to new_storage_resistances_path
    end
  end
   
  def edit

  end

	def csv_import
	    begin
	      StorageResistance.import(params[:file].path)
	      redirect_to storage_resistances_path, notice: "Resistencias al guarde importados corretamente"
	    rescue
	     redirect_to storage_resistances_path, alert: "El archivo cargado contiene errores."
	    end
	end


  def destroy
    if @storage_resistance.destroy
      flash[:success] = 'Resistencia al guarde fue eliminado'
      redirect_to storage_resistances_path
    else
      flash[:error] = @storage_resistance.errors.full_messages.to_sentence
      redirect_to storage_resistances_path
    end
  end

  private

  def storage_resistance_params
     params.permit(['storage_resistance_type_id','week_number','lost_percentage'])
  end

  def find_storage_resistance
    @storage_resistance = StorageResistance.find(params[:id])
  end
	
end
