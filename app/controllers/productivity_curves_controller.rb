class ProductivityCurvesController < ApplicationController
  before_action :authorize, :lock_farms_per_company
  before_action :find_productivity_curve, only: [:edit, :update]
  before_action :find_farm, only: [:index, :create, :destroy]

	def index
    @productivity_curves = @farm.productivity_curves.includes(:variety)
    @varieties = @farm.productivity_curves_varieties
	end

  def new
    @productivity_curve = ProductivityCurve.new
  end

  def create
    @new_productivity_curve = @farm.productivity_curves.new(productivity_curve_params)

    if @new_productivity_curve.save
      flash[:success] = 'Registro creado'
      redirect_to index_route
    else
      flash[:error] = @new_productivity_curve.errors.full_messages.to_sentence
      redirect_to :new_productivity_curve
    end
  end

	def csv_import
		begin
      binding.pry
			@company = Company.find(session[:company_id])
			ProductivityCurve.import(params[:file].path, @company.id)
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

  def edit

  end

  def update
    @productivity_curve.attributes = productivity_curve_params
    if @productivity_curve.save
      flash[:success] = 'Registro actualizado'
      redirect_to index_route
    else
      flash[:error] = @productivity_curve.errors.full_messages.to_sentence
      redirect_to index_route
    end
  end


	private
  def productivity_curve_params
    params.require(:productivity_curve).permit(:week_number, :cost, :production, :cut, :farm_id, :variety_id)
  end

	def find_farm
    @farm = Farm.find(session[:farm_id])
	end

	def index_route
    farm_productivity_curves_path(farm_id: session[:farm_id])
	end

  def find_productivity_curve
    @productivity_curve = ProductivityCurve.find(params[:id])
  end

end
