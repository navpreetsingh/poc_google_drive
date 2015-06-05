# Rails.application.config.middleware.use OmniAuth::Builder do
# 	provider :google_oauth2, AuthDetails["GOOGLE_CLIENT_ID"], AuthDetails["GOOGLE_CLIENT_SECRET"],
# 	{	
# 		:name => "google",	
# 		:scope => "email, profile, drive",
# 		:prompt => 'select_account'	
# 	}
# end