#!/usr/bin/env/ruby

require 'socket'

Current_directory = current_dir = File.dirname(__FILE__)

# Node details
NODE_NAME         = "GSI-SP2016"
USERNAME          = "Administrator"
PASSWORD          = "password@123"
IP_ADDR           = "50.19.204.82"



begin
  s = TCPSocket.new IP_ADDR, 5985
  sleep 2
rescue Errno::ETIMEDOUT => e
  puts "Still waiting..."
  retry
 rescue
  puts "socket exception..."
 endr
 s.close
end



# Define the command to bootstrap the already-provisioned instance with Chef
begin
bootstrap_cmd = [
  "knife bootstrap windows winrm #{IP_ADDR}",
  "-x #{USERNAME}",
  "-P '#{PASSWORD}'",
  "--node-name #{NODE_NAME}",
  "--verbose"
].join(' ')

# Now we can bootstrap the instance with Chef and the configured run list.
status = system(bootstrap_cmd) ? 0 : -1
exit status
end