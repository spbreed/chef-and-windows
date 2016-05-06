# See http://docs.chef.io/config_rb_knife.html for more information on knife configuration options
#Get current directory
current_dir = File.dirname(__FILE__)

#chef settings
chef_server_url          "https://api.chef.io/organizations/sp2016"
node_name                "spbreed"
client_key               "#{current_dir}/spbreed.pem"
validation_key           "#{current_dir}/sp2016-validator.pem"
validation_client_name   "sp2016-validator"
log_level                :info
log_location             STDOUT
cookbook_path            ['C:\Users\kramamoorthy\OneDrive\chef\chef-sharepoint-install\cookbooks']


#AWS settings
knife[:aws_access_key_id] = "A******A"
knife[:aws_secret_access_key] = "k******b"
