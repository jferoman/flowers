class ProductivityCurvesController < ApplicationController
  before_action :authorize, :lock_farms_per_company
  before_action :find_farm, only: [:index, :create, :destroy]

	def index
      @productivity_curves = @farm.productivity_curves
      @varieties = @farm.productivity_curves_varieties
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

	def destroy 
		if params[:variety_id] == "all"
		  ProductivityCurve.where(farm_id: @farm.id).delete_all
		  notice = "Todas las curvas de produción fueron borradas"
		else
      ProductivityCurve.where(farm_id: @farm.id, variety_id: params[:variety_id]).delete_all
      notice = "Las curvas de produción de la variedad: " + Variety.find(params[:variety_id]).name + " fueron borradas"
		end

       redirect_to index_route, notice: notice
	end
	
	private

	def find_farm
       @farm = Farm.find(params[:farm_id])
	end

	def index_route
      farm_productivity_curves_path(farm_id: params[:farm_id])
	end

end
