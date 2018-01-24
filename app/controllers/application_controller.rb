class ApplicationController < ActionController::Base
	# Prevent CSRF attacks by raising an exception.
	# For APIs, you may want to use :null_session instead.

	# protect_from_forgery with: :exception

	def current_user
		@current_user ||= User.find(session[:user_id]) if session[:user_id]
	end

	helper_method :current_user

	def authorize
		redirect_to '/login' unless current_user
	end

	def dashboard
	end

  def index

  end

  def lock_farms_per_company
    if !(session[:company_id] == Farm.find(session[:farm_id]).company.id)
      if !User.find(session[:user_id]).admin
        redirect_to farm_main_reports_path(session[:farm_id]) , notice: "No tiene los permisos para consultar otras fincas."
        return
      end
    end
  end

end
