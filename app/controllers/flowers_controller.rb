class FlowersController < ApplicationController
  before_action :authorize
  before_action :find_flower, only: [:destroy, :edit, :update]

  def index
  	@flowers = Flower.all
  end

  def new
    @flower = Flower.new
  end

  def create
    new_flower = Flower.new({name: flower_params})

    if new_flower.save
      flash[:success] = 'Flor creada'
      redirect_to flowers_path
    else
      flash[:error] = new_flower.errors.full_messages.to_sentence
      redirect_to :new_flower
    end
  end

  def destroy
    if @flower.destroy
      flash[:success] = 'Flor eliminada'
      redirect_to flowers_path
    else
      flash[:error] = @flower.errors.full_messages.to_sentence
      redirect_to flowers_path
    end
  end
  
  def edit

  end

  def update
    @flower.attributes = {name: flower_params}
    if @flower.save
      flash[:success] = 'FLower actualizada'
      redirect_to flowers_path
    else
      flash[:error] = @flower.errors.full_messages.to_sentence
      redirect_to flowers_path
    end
  end

  private

  def flower_params
    params['flower'].require(:name)
  end

  def find_flower
    @flower = Flower.find(params[:id])
  end
end
