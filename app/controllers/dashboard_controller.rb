class DashboardController < ApplicationController  
  before_action :google_session, only: [:working_platform, :upload, :cr_folder]
  
  def home
  end
  
  def google_oauth2
    google_request = request.env["omniauth.auth"]    
  	session[:google_auth] = google_request.credentials.token
    redirect_to dashboard_working_platform_path	
  end
  
  def working_platform
    # client = Google::APIClient.new(:application_name => 'Example Ruby application',:application_version => '1.0.0')
    # drive = client.discovered_api('drive', 'v2')
    # client.authorization.access_token = session[:google_auth]
    # parameters = {}
    # parameters["q"] = "fullText contains 'abc'"
    # files = client.execute(:api_method => drive.files.list, :parameters => parameters)
    # debugger
    if params[:search].present?
    	@files = []  
    	@files << @google_session.file_by_title(params[:search])
    else
    	@files = @google_session.files
    end    
  end
  
  def failure 
  	redirect_to root_url
  end
  
  def upload 	
  file = params["File"]
  file_name = file.original_filename	
	@google_session.upload_from_file(file.tempfile, file_name)
	redirect_to dashboard_working_platform_path  
  end

  def cr_folder
    folder_name = params[:folder]
    @google_session.root_collection.create_subcollection(folder_name)
    redirect_to dashboard_working_platform_path 
  end

end
