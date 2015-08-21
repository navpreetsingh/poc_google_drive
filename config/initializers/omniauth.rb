Constants = YAML.load_file(File.join(Rails.root, 'config', 'google_auth.yml'))
AuthDetails = Constants[Rails.env]

Rails.application.config.middleware.use OmniAuth::Builder do
	provider :google_oauth2, AuthDetails["GOOGLE_CLIENT_ID"], 
	AuthDetails["GOOGLE_CLIENT_SECRET"], 
	{      
    :scope => "email, https://www.googleapis.com/auth/drive",
    :prompt => 'select_account consent'
  } 
end
