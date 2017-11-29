class SessionsController < ApplicationController
  layout 'pages'

  def create
    user = User.find_by_email(params[:email])
    local_url = "/home"

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to local_url
    else
      redirect_to '/login'
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to '/login'
  end
end
