Previous posts shows how to set up CHEF infrastructure for windows automation, provision Ec2 instances using cloud formation templates and configuring Windows Active Directory using CHEF. 

This article covers how to install SQL server 2014 Sp1 using CHEF. This cookbook is based on [azure-quickstart-templates](https://github.com/starkfell/azure-quickstart-templates) from Ryan Irujo(https://github.com/starkfell)

Create new cookbook and update default.rb with install instructions.

This cookbook will
- Download SQL server bits
- Installs .NET 3.5
- Mounts ISO
- Uses cookbooks\Install_SQL_SERVER_2014_SP1\files\SQL_Server_2014_SP1_Configuration_File.ini to install SQL server
    - Adds SQL admin accounts
    - Enables mixed mode
    - Enables named pipes
- Dismounts ISO
- Deletes the temp files
- Restarts the instance

Change cookbooks\Install_SQL_SERVER_2014_SP1\files\SQL_Server_2014_SP1_Configuration_File.ini to suit your custom needs

 ````ruby

# Declaring Variables
iso_url               = "http://care.dlservice.microsoft.com/dl/download/2/F/8/2F8F7165-BB21-4D1E-B5D8-3BD3CE73C77D/SQLServer2014SP1-FullSlipstream-x64-ENU.iso"
iso_path              = "C:\\Windows\\Temp\\SQLServer2014SP1-FullSlipstream-x64-ENU.iso"
sql_config_file_path  = "C:\\Windows\\Temp\\SQL_Server_2014_SP1_Configuration_File.ini"
sql_username          = "sql_service"
sql_password          = "password@123"
sql_agent_svc_act     = "NT AUTHORITY\\Network Service"


# Copy ini file from files directory
cookbook_file 'C:\\Windows\\Temp\\SQL_Server_2014_SP1_Configuration_File.ini' do
    source 'SQL_Server_2014_SP1_Configuration_File.ini'
    action :create
 not_if '($SQL_Server_Service = (gwmi -class Win32_Service | Where-Object {$_.Name -eq "MSSQLSERVER"}).Name -eq "MSSQLSERVER")'
end


#Download the SQL Server 2014 SP1 ISO from a Web Share.
powershell_script 'Download SQL Server 2014 SP1 ISO' do
        code <<-EOH
                $Client = New-Object System.Net.WebClient
                $Client.DownloadFile("#{iso_url}", "#{iso_path}")
                EOH
        guard_interpreter :powershell_script
	not_if '($SQL_Server_Service = (gwmi -class Win32_Service | Where-Object {$_.Name -eq "MSSQLSERVER"}).Name -eq "MSSQLSERVER")'
end


#install .net framework 3.5

powershell_script 'Install .net 3.5 framework' do
        code <<-EOH
                Install-WindowsFeature -name NET-Framework-Core
                EOH
 end


# Mounting the SQL Server 2014 SP1 ISO.
powershell_script 'Mount SQL Server 2014 SP1 ISO' do
        code <<-EOH
                Mount-DiskImage -ImagePath "#{iso_path}"
        if ($? -eq $True)
                {
                        echo "The SQL Server 2014 SP1 ISO was mounted Successfully." > C:\\Windows\\Temp\\_SQL_Server_2014_SP1_ISO_Mounted_Successfully.txt
                        exit 0;
                }

                if ($? -eq $False)
        {
                        echo "The SQL Server 2014 SP1 ISO was unable to be mounted." > C:\\Windows\\Temp\\_SQL_Server_2014_SP1_ISO_Mount_Failed.txt
                        exit 2;
        }
                EOH
        guard_interpreter :powershell_script
	not_if '($SQL_Server_Service = (gwmi -class Win32_Service | Where-Object {$_.Name -eq "MSSQLSERVER"}).Name -eq "MSSQLSERVER")'
end

# Installing SQL Server 2014 SP1 Standard.
powershell_script 'Install SQL Server 2014 SP1 x64' do
        code <<-EOH
                $SQL_Server_ISO_Drive_Letter = (gwmi -Class Win32_LogicalDisk | Where-Object {$_.VolumeName -eq "SQL2014_x64_ENU"}).DeviceID
                cd $SQL_Server_ISO_Drive_Letter\\
                $Install_SQL = ./Setup.exe /q /ACTION=Install /SQLSVCPASSWORD="#{sql_password}" /AGTSVCPASSWORD="#{sql_password}" /ASSVCPASSWORD="#{sql_password}" /ISSVCPASSWORD="#{sql_password}" /RSSVCPASSWORD="#{sql_password}" /IACCEPTSQLSERVERLICENSETERMS /CONFIGURATIONFILE="#{sql_config_file_path}"
                $Install_SQL > C:\\Windows\\Temp\\_SQL_Server_2014_SP1_Install_Results.txt
                EOH
        guard_interpreter :powershell_script
        not_if '($SQL_Server_Service = (gwmi -Class Win32_Service | Where-Object {$_.Name -eq "MSSQLSERVER"}).Name -eq "MSSQLSERVER")'
end


# # Dismounting the SQL Server 2014 SP1 ISO.
powershell_script 'Dismount SQL Server 2014 SP1 ISO' do
        code <<-EOH
                Dismount-DiskImage -ImagePath "#{iso_path}"
                EOH
        guard_interpreter :powershell_script
        only_if { File.exists?(iso_path)}
end


# # Removing the SQL Server 2014 SP1 ISO from the Temp Directory.
powershell_script 'Delete SQL Server 2014 SP1 ISO' do
        code <<-EOH
                [System.IO.File]::Delete("#{iso_path}")
                EOH
        guard_interpreter :powershell_script
        only_if { File.exists?(iso_path)}
end

# # Removing the SQL Server 2014 SP1 Custom Configuration File from the Temp Directory.
powershell_script 'Delete SQL Server 2014 SP1 Custom Configuration File' do
        code <<-EOH
                [System.IO.File]::Delete("#{sql_config_file_path}")
                EOH
        guard_interpreter :powershell_script
        only_if { File.exists?(sql_config_file_path)}
end

 ````ruby
 
 Now change the run list and run the knife command
 
 ````
RUN_LIST          = "recipe[Configure_SQL_Disk_F],recipe[Install_SQL_Server_2014_SP1]"
RUN_LIST_REMOVE   =  "recipe[windows_ad],recipe[custom_ad],recipe[custom_ad::users]"
````
 ````
 knife exec .\force-chef-windows.rb
 ````
 RDP to server and verify all the settings.
 
 
 ![SQL](http://www.devopsrocks.com/mywbblog/wp-content/uploads/2016/04/image020.png)
 
  ![SQL](http://www.devopsrocks.com/mywbblog/wp-content/uploads/2016/04/image021.png)
 
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
