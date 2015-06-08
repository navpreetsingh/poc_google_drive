if Rails.env == "development"
	AuthDetails = YAML.load_file(File.join(Rails.root, 'config', 'auth_development.yml'))
elsif Rails.env == "production"
	AuthDetails = YAML.load_file(File.join(Rails.root, 'config', 'auth_production.yml'))
end



Rails.application.config.middleware.use OmniAuth::Builder do
	provider :google_oauth2, AuthDetails["GOOGLE_CLIENT_ID"], 
	AuthDetails["GOOGLE_CLIENT_SECRET"], 
	{      
      :scope => "email, https://www.googleapis.com/auth/drive",
      :prompt => 'select_account'      
    } 
end
