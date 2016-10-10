class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  # Raise an exception in case a file is not found
  def file_not_found
    raise ActionController::RoutingError.new('File not found error.  Either the url is incorrect either the file is not on the server anymore.')
  end
  
  # Force to have the session id set
  def session_set?
    if session[:session_id].nil?
      session[:init] = true
    end
  end
    
  # Check if it is the first visit
  def first_time_visiting?
    if cookies.permanent[:first_time].nil?
      cookies.permanent[:first_time] = false
      @quick_start = true
    end
  end
  
  def set_gon_var
    gon.maximum_file_size = eval(Rails.configuration.x.app_config['maximum_file_size']) 
  end
end
