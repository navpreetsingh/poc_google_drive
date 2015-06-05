class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
	def google_oauth2
		google_request = request.env["omniauth.auth"]
		session[:google_auth] = google_request.credentials.token
		@google_session = GoogleDrive.login_with_oauth(session[:google_auth])
		redirect_to dashboard_drive_path(@google_session)
		# Root Folder
		# @google_session.root_collection

		# @user = User.from_omniauth(request.env["omniauth.auth"])

		# debugger
		# if @user.persisted?
		# 	flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Google"
		# 	sign_in_and_redirect @user, :event => :authentication
		# else
		# 	session["devise.google_data"] = request.env["omniauth.auth"]
		# 	redirect_to new_user_registration_url
		# end
	end

end
