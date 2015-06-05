class DashboardController < ApplicationController
  def home
  end
  def google_oauth2
  	google_request = request.env["omniauth.auth"]
	session[:google_auth] = google_request.credentials.token
	@google_session = GoogleDrive.login_with_oauth(session[:google_auth])	
	debugger	
	render :google_oauth2
  end
  def failure 
  	redirect_to root_url
  end
  def upload 	
  	file = params["File"]
  	file_name = file.original_filename
	@google_session = GoogleDrive.login_with_oauth(session[:google_auth])	
	@google_session.upload_from_file(file.tempfile, file_name)
	redirect_to dashboard_google_oauth2_path
  end
end
