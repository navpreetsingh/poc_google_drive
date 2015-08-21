class DashboardController < ApplicationController  
  before_action :client, only: [:working_platform, :upload, :cr_folder]
  
  def home
  end
  
  def google_oauth2    
    # google_request = request.env["omniauth.auth"]
    # google_info = google_request.info
    # google_credentials = google_request.credentials    
    # User.create(first_name: google_info.first_name, last_name: google_info.last_name, email: google_info.email, image_link: google_info.image, access_token: google_credentials.token, expires_at: Time.at(google_credentials.expires_at), refresh_token: google_credentials.refresh_token)        
  	# session[:access_token] = google_request.credentials.token    
    redirect_to dashboard_working_platform_path	
  end
  
  def working_platform
    if params[:search].present?                 	
    	@files = @client.search_list(params[:search])
    elsif params[:parent_id].present?   
      @files = @client.children_list(params[:parent_id])       
    elsif params[:back].present?
      @files = @client.parent_list(params[:back])
    else
  	  @files = @client.root_list      
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
