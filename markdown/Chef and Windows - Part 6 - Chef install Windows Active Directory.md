Previous posts shows how to set up CHEF infrastructure for windows automation and provision Ec2 instances using cloud formation templates. This post goes through configuring Windows Active Directory using CHEF. AD configuration can be automated using PowerShell, DCPROMO and DSQuery tools which are natively available on the windows server. But instead of writing bunch of PS/CMD scripts, a community CHEF cookbook can be used.

Advantage of using is community chef cookbook is it saves you from writing scripts and it is tested/reviewed by multiple users. It is advisable to review the comments and issues of these cookbooks.

In this case [Windows_AD](https://supermarket.chef.io/cookbooks/windows_ad) cookbook is used to provision AD. This cookbook is supported on Win 2008 R2 and above.

To get this started, create a new cookbook 'custom_ad'. BerkShelf is an useful tool to manage cookbooks and its dependencies. Berkshelf is now included as part of the ChefDK, so no isntallation is required.

 berks cookbook custom_ad
 
  ![node list](http://www.devopsrocks.com/mywbblog/wp-content/uploads/2016/04/image016.png)
 
 This will create all the neccassary file structure for a cookbook
 
 ![node list](http://www.devopsrocks.com/mywbblog/wp-content/uploads/2016/04/image015.png)
 
 Now add the cookbook dependencies to the berksfile ie 'windows_ad'
 
 ````ruby
 source "https://supermarket.chef.io"

 metadata

 cookbook 'windows_ad', '~> 0.4.5'
 ````
 
 Run 'berks install' to set dependencies
 
 ![node list](http://www.devopsrocks.com/mywbblog/wp-content/uploads/2016/04/image016.png)
 
 ````powershell
 cd custom_ad
 
 berks install
 ````
 
 Download these dependencies by running 'berks vendor'

  ````powershell
 berks vendor ..\..\cookbooks\
  ````
  
>note: Any dependent cookbook needs to be available on Chef server.

Open custom_ad\recipes\default.rb and add the below script to install AD and restart


 ````ruby
 windows_ad_domain "gsi.com" do
  action :create
  type "forest"
  safe_mode_pass "password@123"
  domain_user "adadmin"
  domain_pass "password@123"
  net_bios_name "gsi"
end

#restart after
reboot 'now' do
  action :request_reboot
  reason 'Cannot continue Chef run without a reboot.'
end
 ````

Create custom_ad\recipes\users.rb to create new users and add users to group

 ````ruby

# Create user "ad admin" in the Users OU
    windows_ad_user "Ad Admin" do
      action :create
      domain_name "gsi.com"
      ou "users"
      options ({ "samid" => "adadmin",
             "upn" => "adadmin@gsi.com",
             "fn" => "ad",
             "ln" => "admin",
             "display" => "Admin, Ad",
             "disabled" => "no",
             "pwd" => "password@123"
           })
    end

# Create user "SQL" in the Users OU
    windows_ad_user "Sql Service" do
      action :create
      domain_name "gsi.com"
      ou "users"
      options ({ "samid" => "sqlservice",
             "upn" => "sqlservice@gsi.com",
             "fn" => "sql",
             "ln" => "service",
             "display" => "Service, Sql",
             "disabled" => "no",
             "pwd" => "password@123"
           })
    end
    
  # Create user "SP admin" in the Users OU
    windows_ad_user "SP Admin" do
      action :create
      domain_name "gsi.com"
      ou "users"
      options ({ "samid" => "spadmin",
             "upn" => "spadmin@gsi.com",
             "fn" => "sp",
             "ln" => "admin",
             "display" => "Admin, SP",
             "disabled" => "no",
             "pwd" => "password@123"
           })
    end
    
      # Create user "SP farm" in the Users OU
    windows_ad_user "SP Farm" do
      action :create
      domain_name "gsi.com"
      ou "users"
      options ({ "samid" => "spfarm",
             "upn" => "spfarm@gsi.com",
             "fn" => "sp",
             "ln" => "farm",
             "display" => "Farm, SP",
             "disabled" => "no",
             "pwd" => "password@123"
           })
    end
    
      # Create user "SP service" in the Users OU
    windows_ad_user "SP Service" do
      action :create
      domain_name "gsi.com"
      ou "users"
      options ({ "samid" => "spservice",
             "upn" => "spservice@gsi.com",
             "fn" => "sp",
             "ln" => "service",
             "display" => "Service, SP",
             "disabled" => "no",
             "pwd" => "password@123"
           })
    end
    
        # Create user "SP crawl" in the Users OU
    windows_ad_user "SP Crawl" do
      action :create
      domain_name "gsi.com"
      ou "users"
      options ({ "samid" => "spcrawl",
             "upn" => "spcrawl@gsi.com",
             "fn" => "sp",
             "ln" => "crawl",
             "display" => "Crawl, SP",
             "disabled" => "no",
             "pwd" => "password@123"
           })
    end
    
        # Create user "SP apppool" in the Users OU
    windows_ad_user "SP AppPool" do
      action :create
      domain_name "gsi.com"
      ou "users"
      options ({ "samid" => "spapppool",
             "upn" => "spapppool@gsi.com",
             "fn" => "sp",
             "ln" => "apppool",
             "display" => "AppPool, SP",
             "disabled" => "no",
             "pwd" => "password@123"
           })
    end
    
    # Create user "sql admin" in the Users OU
    windows_ad_user "sql admin" do
      action :create
      domain_name "gsi.com"
      ou "users"
      options ({ "samid" => "sqladmin",
             "upn" => "sqladmin@gsi.com",
             "fn" => "sql",
             "ln" => "admin",
             "display" => "admin, sql",
             "disabled" => "no",
             "pwd" => "password@123"
           })
    end
    
    # Add sql admin to admin group for RDP and local admin access
    windows_ad_group_member 'sql admin' do
        action :add
        group_name  'Enterprise Admins'
        domain_name 'gsi.com'
        user_ou 'Users'
        group_ou 'Users'
   end
   
   windows_ad_group_member 'ad admin' do
        action :add
        group_name  'Enterprise Admins'
        domain_name 'gsi.com'
        user_ou 'Users'
        group_ou 'Users'
   end
   
    windows_ad_group_member 'sp admin' do
        action :add
        group_name  'Enterprise Admins'
        domain_name 'gsi.com'
        user_ou 'Users'
        group_ou 'Users'
   end
   
    windows_ad_group_member 'sp farm' do
        action :add
        group_name  'Enterprise Admins'
        domain_name 'gsi.com'
        user_ou 'Users'
        group_ou 'Users'
   end
 ````
 
 Now upload all the cookbooks to chef server.
 
  ````
  knife upload .\cookbooks\
  ````
 
 Push the cookbooks to chef nodes by running "Knife Winrm" command. 
 
 knife exec .\force-chef-windows.rb
 
 ````ruby
 #!/usr/bin/env/ruby

require 'socket'


Current_directory = current_dir = File.dirname(__FILE__)

# Node details
NODE_NAME         = "GSI-SP2016"
RUN_LIST          = "recipe[windows_ad],recipe[custom_ad]"
RUN_LIST_REMOVE   =  ""
USERNAME          = "administrator"
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
 
 ````
  
 After installing AD, update the run list with 'recipe[custom_ad::users]' and run it again to create users
 
````
RUN_LIST          = "recipe[custom_ad::users]"
RUN_LIST_REMOVE   =  "recipe[windows_ad],recipe[custom_ad]"
````
 ````
 knife exec .\force-chef-windows.rb
 ````
 
 
 ![AD](http://www.devopsrocks.com/mywbblog/wp-content/uploads/2016/04/image018.png)
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

