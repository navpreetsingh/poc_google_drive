require 'google/api_client'
require 'google/api_client/auth/installed_app'

class GoogleDrive
	def initialize(user_token)
		@client = Google::APIClient.new(:application_name => "Archiving")
		google_auth = Constants["native"]
		debugger
		request = Google::APIClient::InstalledAppFlow.new({
			:client_id => google_auth["GOOGLE_CLIENT_ID"],
			:client_secret => google_auth["GOOGLE_CLIENT_SECRET"],
			:scope => "https://www.googleapis.com/auth/drive"})
		@client.authorization = request.authorize(user_token)
		@drive_api = @client.discovered_api('drive', 'v2')
	end

	def files(search=nil)
		@client.execute!(:api_method => @drive_api.files.list, :parameters => { :maxResults => 10 })
	end

	def upload(file)

	end

	def create_file(file)

	end

	def create_folder(folder)

	end
end

