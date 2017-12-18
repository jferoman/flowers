class WeeksController < ApplicationController
  before_action :find_week, only: [:edit, :update]

  def index
    @weeks = Week.all
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

  private
  def week_params
    params.require(:week).permit(:initial_day, :week)
  end

  def find_week
    @week = Week.find(params[:id])
  end
end
