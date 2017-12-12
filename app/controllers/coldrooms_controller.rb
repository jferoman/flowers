class ColdroomsController < ApplicationController
  before_action :authorize, :lock_farms_per_company
  before_action :find_coldroom, only: [:destroy, :edit, :update]
  before_action :find_farm, only: [:index, :create]

  def index
    @coldrooms = @farm.coldrooms
  end

  def new
    @coldroom = Coldroom.new
  end

  def create
    @new_coldroom = @farm.coldrooms.new(coldroom_params)

    if @new_coldroom.save
      flash[:success] = 'Cuarto frio creado'
      redirect_to index_route
    else
      flash[:error] = @new_coldroom.errors.full_messages.to_sentence
      redirect_to :new_coldroom
    end
  end

  def destroy
    if @coldroom.destroy
      flash[:success] = 'Cuarto frio eliminado'
      redirect_to index_route
    else
      flash[:error] = @coldroom.errors.full_messages.to_sentence
      redirect_to index_route
    end
  end

  def edit
  end

  def update
    @coldroom.attributes = coldroom_params
    if @coldroom.save
      flash[:success] = 'Bloque actualizado'
      redirect_to index_route
    else
      flash[:error] = @coldroom.errors.full_messages.to_sentence
      redirect_to index_route
    end
  end

  private
  def coldroom_params
    params.require(:coldroom).permit(:name, :capacity, :farm_id)
  end

  def find_farm
    @farm = Farm.find(session[:farm_id])
  end

  def index_route
    "/farms/" + session[:farm_id].to_s + "/coldrooms"
  end

  def find_coldroom
    @coldroom = Coldroom.find(params[:id])
  end
end
