class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def get_layout  	
  	request.xhr? || request.headers['X-PJAX'] ? nil : 'application'
  end

end
