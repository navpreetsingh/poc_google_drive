Rails.application.config.middleware.use OmniAuth::Builder do
	provider :google_oauth2, AuthDetails["GOOGLE_CLIENT_ID"], AuthDetails["GOOGLE_CLIENT_SECRET"],
	{
		:name => "google",
		:scope => ['https://www.googleapis.com/auth/drive.file', 'email', 'profile'],
		:prompt => "select_account",
	}
end