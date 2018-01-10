class WeeksController < ApplicationController
  before_action :find_week, only: [:edit, :update]

  def index
    @weeks = Week.all
    @years = Week.all.pluck(:initial_day).uniq{|x| x.year}

  end

  def edit

  end

  def update

    @week.attributes = week_params
    if @week.save
      flash[:success] = 'Informacion de la semana actualizada'
      redirect_to weeks_path
    else
      flash[:error] = @week.errors.full_messages.to_sentence
      redirect_to weeks_path
    end
  end

  def import_weeks
    begin
      Week.import(params[:file].path)
      redirect_to weeks_path, notice: "Calendario importado corretamente."
    rescue
     redirect_to weeks_path, alert: "El archivo cargado contiene errores."
    end
  end

  def batch_delete
    binding.pry
    if params[:year] == "all"
      Week.delete_all
      notice = "Todas las fechas fueron borradas."
    else
      Week.where("extract(year from initial_day) = ? ", params[:year]).delete_all
      notice = "Las fechas del ano " + params[:year] + " fueron borradas."
    end
      redirect_to weeks_path, notice: notice
  end

  private
  def week_params
    params.require(:week).permit(:initial_day, :week)
  end

  def find_week
    @week = Week.find(params[:id])
  end
end
