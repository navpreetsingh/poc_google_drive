require 'google/api_client'
require 'google/api_client/auth/installed_app'

class GoogleDrive
	@@default_parameters = {fields: "items(alternateLink,description,downloadUrl,fileSize,id,mimeType,parents(id,isRoot),title)"}

	def initialize(user_id=nil)
		google_auth = AuthDetails
		google_details = User.find_by_id(user_id)
		
		@client = Google::APIClient.new(:application_name => "Archiving")				
		if google_details.nil?
			@request = Google::APIClient::InstalledAppFlow.new({
				:client_id => google_auth["GOOGLE_CLIENT_ID"],
				:client_secret => google_auth["GOOGLE_CLIENT_SECRET"],
				:scope => "https://www.googleapis.com/auth/drive",
				:redirect_uri => "urn:ietf:wg:oauth:2.0:oob",
				:prompt => 'select_account consent',				
				:include_granted_scopes => true				
			})
			@client.authorization = @request.authorize			
		else			
			@client.authorization.client_id = google_auth["GOOGLE_CLIENT_ID"]
			@client.authorization.client_secret = google_auth["GOOGLE_CLIENT_SECRET"]
			@client.authorization.redirect_uri = "urn:ietf:wg:oauth:2.0:oob"
			google_details = User.find(user_id)			
			if google_details.expire
				@client.authorization.grant_type = 'refresh_token'
				@client.authorization.refresh_token = google_details.refresh_token
				@request = @client.authorization.fetch_access_token!					
				google_details.update_attributes(access_token: @request["access_token"],
					expires_at: Time.now + 1.hour )
			end
			@client.authorization.access_token = google_details.access_token			
		end	
		@drive_api = @client.discovered_api('drive', 'v2')		
	end

	def request_info
		@request
	end

	def root_list(parameters = @@default_parameters)
		root_list_params = {q:"'root' in parents and trashed=false", orderBy: "folder"}
		final_parameters = parameters.merge(root_list_params)		
		lists = Hashie::Mash.new(JSON.parse(@client.execute!(:api_method => @drive_api.files.list, :parameters => final_parameters).body))		
		lists.items		
	end

	def children_list(parent_id, parameters = @@default_parameters)
		children_list_params = {q:"'#{parent_id}' in parents and trashed=false", orderBy: "folder"}
		final_parameters = parameters.merge(children_list_params)
		lists = Hashie::Mash.new(JSON.parse(@client.execute!(:api_method => @drive_api.files.list, :parameters => final_parameters).body))
		lists.items		
	end

	def parent_list(file_id, parameters = @@default_parameters)
		parent_details = Hashie::Mash.new(JSON.parse(@client.execute!(:api_method => @drive_api.files.get, :parameters => {:fileId => file_id, fields: "parents(id,isRoot)"}).body))		
		parent_id = parent_details.parents.first.id		
		parent_list_params = {q:"'#{parent_id}' in parents and trashed=false", orderBy: "folder"}
		final_parameters = parameters.merge(parent_list_params)
		lists = Hashie::Mash.new(JSON.parse(@client.execute!(:api_method => @drive_api.files.list, :parameters => final_parameters).body))
		lists.items
	end

	def mime_type_list(type)
		# CONSTANTS TYPE LIST
		# google_type = Constants["Google_Type"][type]

		mime_type_list_params = {q:"trashed=false and mimeType = '#{google_type}'", orderBy: "folder"}
		final_parameters = parameters.merge(children_list_params)
		lists = Hashie::Mash.new(JSON.parse(@client.execute!(:api_method => @drive_api.files.list, :parameters => final_parameters).body))
		lists.items	
	end

	def search_list(search)
		search_params = {q:"trashed=false and title contains '#{search}' or fullText contains '#{search}'"}
		final_parameters = parameters.merge(children_list_params)
		lists = Hashie::Mash.new(JSON.parse(@client.execute!(:api_method => @drive_api.files.list, :parameters => final_parameters).body))
		lists.items
	end

	def upload(file)

	end

	def create_file(file)

	end

	def create_folder(folder)

	end
end


# require 'google/api_client'
# require 'google/api_client/auth/installed_app'

# class GoogleDrive
# 	@@default_parameters = {fields: "items(alternateLink,description,downloadUrl,fileSize,id,mimeType,parents(id,isRoot),title)"}
# 	@@google_client_id = "286769101745-jjkd2c0lff0t5d9sushlhtmu4hiuqvan.apps.googleusercontent.com"
# 	@@google_client_secret = "2ROu1PuK6ha6W-SVozTwV0_4"

# 	def initialize(access_token=nil, refresh_token = nil)
# 		google_auth = AuthDetails

# 		@client = Google::APIClient.new(:application_name => "Archiving")					
# 		@client.authorization.client_id = @@google_client_id
# 		@client.authorization.client_secret = @@google_client_secret
# 		@client.authorization.redirect_uri = "urn:ietf:wg:oauth:2.0:oob"				
# 		if access_token.nil?
# 			@client.authorization.grant_type = 'refresh_token'
# 			@client.authorization.refresh_token = refresh_token
# 			request = @client.authorization.fetch_access_token!
# 			@access_token = request["access_token"]								
# 		end
# 		@client.authorization.access_token = @access_token
# 		@drive_api = @client.discovered_api('drive', 'v2')		
# 	end

# 	def get_new_access_token
# 		@access_token
# 	end

# 	def root_list(parameters)
# 		root_list_params = {q:"'root' in parents and trashed=false", orderBy: "folder"}
# 		final_parameters = parameters.merge(root_list_params)		
# 		lists = Hashie::Mash.new(JSON.parse(@client.execute!(:api_method => @drive_api.files.list, :parameters => final_parameters).body))		
# 		lists.items		
# 	end

# 	def children_list(parent_id, parameters = @@default_parameters)
# 		children_list_params = {q:"'#{parent_id}' in parents and trashed=false", orderBy: "folder"}
# 		final_parameters = parameters.merge(children_list_params)
# 		lists = Hashie::Mash.new(JSON.parse(@client.execute!(:api_method => @drive_api.files.list, :parameters => final_parameters).body))
# 		lists.items		
# 	end

# 	def parent_list(file_id, parameters = @@default_parameters)
# 		parent_details = Hashie::Mash.new(JSON.parse(@client.execute!(:api_method => @drive_api.files.get, :parameters => {:fileId => file_id, fields: "parents(id,isRoot)"}).body))		
# 		parent_id = parent_details.parents.first.id		
# 		parent_list_params = {q:"'#{parent_id}' in parents and trashed=false", orderBy: "folder"}
# 		final_parameters = parameters.merge(parent_list_params)
# 		lists = Hashie::Mash.new(JSON.parse(@client.execute!(:api_method => @drive_api.files.list, :parameters => final_parameters).body))
# 		lists.items
# 	end

# 	def mime_type_list(type)
# 		# CONSTANTS TYPE LIST
# 		# google_type = Constants["Google_Type"][type]

# 		mime_type_list_params = {q:"trashed=false and mimeType = '#{google_type}'", orderBy: "folder"}
# 		final_parameters = parameters.merge(children_list_params)
# 		lists = Hashie::Mash.new(JSON.parse(@client.execute!(:api_method => @drive_api.files.list, :parameters => final_parameters).body))
# 		lists.items	
# 	end

# 	def search_list(search)
# 		search_params = {q:"trashed=false and title contains '#{search}' or fullText contains '#{search}'"}
# 		final_parameters = parameters.merge(children_list_params)
# 		lists = Hashie::Mash.new(JSON.parse(@client.execute!(:api_method => @drive_api.files.list, :parameters => final_parameters).body))
# 		lists.items
# 	end

# 	def upload(file)

# 	end

# 	def create_file(file)

# 	end

# 	def create_folder(folder)

# 	end

# 	class << self
# 		def parameters = (parameters)
# 			@@default_parameters = parameters 
# 		end

# 		def google_client_id = (client_id)
# 			@@google_client_id = client_id
# 		end

# 		def google_client_secret = (client_secret)
# 			@@google_client_secret = client_secret
# 		end
# 	end
# end

