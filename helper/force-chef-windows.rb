#!/usr/bin/env/ruby

require 'socket'


Current_directory = current_dir = File.dirname(__FILE__)

# Node details
NODE_NAME         = "GSI-SP2016"
RUN_LIST          = "recipe[sharepoint_2016]"
RUN_LIST_REMOVE   =  "recipe[Configure_SQL_Disk_F],recipe[Install_SQL_Server_2014_SP1]"
#RUN_LIST_REMOVE   =  "recipe[windows_ad],recipe[custom_ad],recipe[Configure_SQL_Disk_F],recipe[Install_SQL_Server_2014_SP1],recipe[custom_ad::users]"
USERNAME          = "gsi\\spadmin"
#USERNAME          = "administrator"
PASSWORD          = "password@123"
IP_ADDR           = "50.19.204.82"



begin
removerunlist_cmd = [
  "knife node run_list remove #{NODE_NAME}",
  "#{RUN_LIST_REMOVE}",
  "--verbose"
].join(' ')

puts removerunlist_cmd
status = system(removerunlist_cmd) ? 0 : -1
end


begin
addrunlist_cmd = [
  "knife node run_list add #{NODE_NAME}",
  "#{RUN_LIST}",
  "--verbose"
].join(' ')

puts addrunlist_cmd
status = system(addrunlist_cmd) ? 0 : -1
end




# Define the command to bootstrap the already-provisioned instance with Chef
begin
chefrun_cmd = [
  "knife winrm #{IP_ADDR}",
  "'chef-client -c c:/chef/client.rb'",
  "-m -x #{USERNAME}",
  "-P '#{PASSWORD}'"
].join(' ')

puts chefrun_cmd
status = system(chefrun_cmd) ? 0 : -1
exit status
end

#knife winrm "52.2.12.27" "chef-client -c c:/chef/client.rb" -m -x Administrator -P "password@123"