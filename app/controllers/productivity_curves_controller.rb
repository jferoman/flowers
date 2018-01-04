class ProductivityCurvesController < ApplicationController
  before_action :authorize, :lock_farms_per_company
  before_action :find_farm, only: [:index, :create]

	def index
      @productivity_curves = @farm.productivity_curves
	end

	def csv_import
		begin
			@company = Company.find(session[:company_id])
			ProductivityCurve.import(params[:file].path,@company.id)
			redirect_to index_route, notice: "Curvas de produción importadas corretamente"
		rescue
		  redirect_to index_route , alert: "El archivo cargado contiene errores."
		  send_file file_path
		end
	end
	
	private

	def find_farm
       @farm = Farm.find(params[:farm_id])
	end

	def index_route
    farm_productivity_curves_path(farm_id: params[:farm_id])
	end

end
