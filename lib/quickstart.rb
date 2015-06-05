require 'rubygems'
require 'google/api_client'
require 'launchy'
require 'byebug'

# Get your credentials from the console
CLIENT_ID = "286769101745-uft1t84cg15e981m5dc2hln96qb7olfl.apps.googleusercontent.com"
#AuthDetails["GOOGLE_CLIENT_ID"]
CLIENT_SECRET = "Zn6IpXs7lNKc8MQxTF4TqGds"
# AuthDetails["GOOGLE_CLIENT_SECRET"]
OAUTH_SCOPE = 'https://www.googleapis.com/auth/drive'
REDIRECT_URI = 'urn:ietf:wg:oauth:2.0:oob'

# Create a new API client & load the Google Drive API
client = Google::APIClient.new
drive = client.discovered_api('drive', 'v2')

# Request authorization
client.authorization.client_id = CLIENT_ID
client.authorization.client_secret = CLIENT_SECRET
client.authorization.scope = OAUTH_SCOPE
client.authorization.redirect_uri = REDIRECT_URI

uri = client.authorization.authorization_uri
Launchy.open(uri)

# Exchange authorization code for access token
$stdout.write  "Enter authorization code: "
client.authorization.code = gets.chomp
client.authorization.fetch_access_token!
debugger

# Insert a file
file = drive.files.insert.request_schema.new({
  'title' => 'My document',
  'description' => 'A test document',
  'mimeType' => 'text/plain'
})

media = Google::APIClient::UploadIO.new('document.txt', 'text/plain')
result = client.execute(
  :api_method => drive.files.insert,
  :body_object => file,
  :media => media,
  :parameters => {
    'uploadType' => 'multipart',
    'alt' => 'json'})

# Pretty print the API result
jj result.data.to_hash