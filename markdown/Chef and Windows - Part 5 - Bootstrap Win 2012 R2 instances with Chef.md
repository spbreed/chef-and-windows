Previous posts covered how to set up CHEF infrastructure for windows automation and provision Ec2 instances using cloud formation templates. This goes through how to bootstrap a Windows instance with Chef

Note
----

> Most fundamental requirment to bootstrap an windows/linux instance with Chef is that instance should be accessible from the Chef server. In case of hosted Chef, the instance should be provisoned in the public subnet with static public IP associated with it. In case of private subnet scenarios where instances within private subnets cannot receive traffic directly from the Internet and can only send outbound traffic, A SSH enabled [NAT instance](http://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/VPC_NAT_Instance.html) should be used. Knife commands presents with the options to create EC2 instances in both private and public subnets.

![wsman](http://www.devopsrocks.com/mywbblog/wp-content/uploads/2016/04/image010.png)

In this scenario, a public subnet is used in the cloud formation template. (Refer previous post for more details). Below knife script is used to bootstrap the EC2 instance.


````ruby
 knife bootstrap windows winrm #{IP_ADDR}"
  -x #{USERNAME}
  -P '#{PASSWORD}
  --node-name #{NODE_NAME}
  --verbose

````

Note
----

> To make any changes to the AWS, an AWS access key ID and AWS Secret is required. This is generated via IAM console. For more details refer http://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSGettingStartedGuide/AWSCredentials.html

Its recommended to store all the secret keys and tokens in the Chef databags for the use in cookbooks and in the knife configuration file in case of using them on Knife commands.

All the config settings of knife tool is available on knife.rb located found under .chef folder. Here is a sample knife.rb with AWS keys

````ruby
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
knife[:aws_access_key_id] = "A***********A"
knife[:aws_secret_access_key] = "k**************b4db"
````

Its tedious task to type the knife commands in the console everytime an instance needs to be bootstrap, instead I use the below ruby script to check if the WinRM port (TCP 5985) is open and to run the bootstrap command.

````ruby
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

````
![Bootstrap](http://www.devopsrocks.com/mywbblog/wp-content/uploads/2016/04/image012.png)

After successful install on the remote node make sure the server is registered on the chef console.
Now run 'chef node list' to list the bootstraped nodes

![node list](http://www.devopsrocks.com/mywbblog/wp-content/uploads/2016/04/image013.png)

---
>This blog Series

[Chef and Windows - Part 1 - Why DevOps?](markdown/Chef and Windows - Part 1 - Why DevOps.md)

[Chef and Windows - Part 2 - Configure Chef Workstation](markdown/Chef and Windows - Part 2 - Configure Chef Workstation.md)

[Chef and Windows - Part 3 - Chef basics](markdown/Chef and Windows - Part 3 - Chef basics.md)

[Chef and Windows - Part 4 - Create Win 2012 R2 instance in AWS using cloud formation](markdown/Chef and Windows - Part 4 - Create Win 2012 R2 instances in AWS using cloud formation.md)

[Chef and Windows - Part 5 - Bootstrap Win 2012 R2 instances with Chef](markdown/Chef and Windows - Part 5 - Bootstrap Win 2012 R2 instances with Chef.md)

[Chef and Windows - Part 6 - Chef install Windows Active Directory](markdown/Chef and Windows - Part 6 - Chef install Windows Active Directory.md)

[Chef and Windows - Part 7 - Chef install SQL server 2014](markdown/Chef and Windows - Part 7 - Chef install SQL server 2014.md)

[Chef and Windows - Part 8 - Chef install SharePoint 2016](markdown/Chef and Windows - Part 8 - Chef install SharePoint 2016.md)

---
>Source code

[https://github.com/spbreed/chef-and-window](https://github.com/spbreed/chef-and-windows)

---   


