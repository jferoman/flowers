class SubmarketWeeksController < ApplicationController

  before_action :authorize, :lock_farms_per_company
  before_action :find_submarket_week, only: [:destroy, :edit, :update]
  before_action :find_company, only: [:index, :new]

  def index
    gon.events = []
    @submarket_weeks = @company.submarket_weeks.includes(:submarket, :week)
    @submarkets = Submarket.where(id: @submarket_weeks.pluck(:submarket_id).uniq)

    @submarket_weeks.each do |sb|
      gon.events << {
        title: sb.submarket.name,
        start: sb.week.initial_day,
        end: sb.week.initial_day.end_of_week ,
        backgroundColor: '#0073b7',
        borderColor: '#0073b7'
      }
    end

  end

  def new
    @submarket_week = SubmarketWeek.new
  end

  def create
    @new_submarket_week = SubmarketWeek.new(submarket_week_params)

    if @new_submarket_week.save
      flash[:success] = 'Temporada por submercado creada'
      redirect_to submarket_weeks_path
    else
      flash[:error] = @new_submarket_week.errors.full_messages.to_sentence
      redirect_to :new_submarket_week
    end
  end

  def batch_delete

    if params[:submarket_id] == "all"
      SubmarketWeek.delete_all
      notice = "Todas las temporadas por submercado fueron borradas."
    else
      SubmarketWeek.where(submarket_id: params[:submarket_id]).delete_all
      notice = "Las temporadas del submercado " + Submarket.find(params[:submarket_id]).name + " fueron borradas."
    end
      redirect_to submarket_weeks_path, notice: notice
  end

  def import
    begin
      file_path = SubmarketWeek.import(params[:file].path)
    rescue Exception => e
      p e
    end

    if file_path.is_a? String
      redirect_to submarket_weeks_path, alert: "El archivo cargado contiene errores."
      send_file file_path
    else
      redirect_to submarket_weeks_path, notice: "Temporadas de submercados importados corretamente"
    end
  end

  private
  def submarket_week_params
    params.require(:submarket_week).permit(:week_id, :submarket_id)
  end

  def find_submarket_week
    @submarket_week = SubmarketWeek.find(params[:id])
  end

  def find_company
    @company = Company.find(session[:company_id])
  end
end
