require 'google_drive'
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  after_filter :set_header_for_iframe
 

  private
  def google_session
  	# @google_session ||= GoogleDrive.login_with_oauth(session[:google_auth])
    @google_session ||= GoogleDrive.new(session[:google_auth])
  	# client = Google::APIClient.new(:application_name => 'Example Ruby application',:application_version => '1.0.0')
  	# drive = client.discovered_api('drive', 'v2')
  	# client.authorization.access_token = session[:google_auth]
  end
  def client            
    @client ||= GoogleDrive.new(User.first.id)    
  end

  def set_header_for_iframe 
    response.headers.delete "X-Frame-Options" 
  end 

end


