class ApplicationController < ActionController::Base
	# Prevent CSRF attacks by raising an exception.
	# For APIs, you may want to use :null_session instead.
	
	# EDC Commented for user autentication 
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

	def post_api
		session[:idf_group_id] = params[:idf_group_id]
		reload params[:path]
	end
    
    def index

    end

end
