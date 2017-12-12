class WeeksController < ApplicationController

  def index
    @weeks = Week.all
  end

  def new

  end

  def create

  end

  def import_weeks
    begin
      Week.import(params[:file].path)
      redirect_to weeks_path, notice: "Calendario importado corretamente."
    rescue
     redirect_to weeks_path, alert: "El archivo cargado contiene errores."
    end
  end
end
