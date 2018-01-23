class SessionsController < ApplicationController
  layout 'pages'

  def create
    user = User.find_by_email(params[:email])
    local_url = "/home"

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      session[:farm_id] = user.default_farm
      session[:company_id] = Farm.find(user.default_farm).company_id
      redirect_to local_url
    else
      redirect_to '/login'
    end
  end

  def destroy
    session[:user_id] = nil
    session[:farm_id] = nil
    session[:company_id] = nil
    redirect_to '/login'
  end

  def change_farm
    session[:farm_id] = params[:farm_id]
    respond_to do |format|
      format.json { render json: { url: home_path(farm_id: params[:farm_id]) } }
    end
  end
end
