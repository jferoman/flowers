class StorageResistancesController < ApplicationController

	def index
		@storage_resistance_types = StorageResistanceType.all
		@storage_resistances = StorageResistance.all
	end

	def csv_import
    begin
      StorageResistance.import(params[:file].path)
      redirect_to storage_resistances_path, notice: "Resistencias al guarde importados corretamente"
    rescue
     redirect_to storage_resistances_path, alert: "El archivo cargado contiene errores."
    end
	end
	
end
