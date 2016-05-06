#
# Cookbook Name:: Install_SQL_Server_2014_SP1
# Recipe:: default
#
# Copyright (c) 2015 Ryan Irujo, All Rights Reserved.
#
#
# Additional Notes:   The 'SQL_Server_2014_SP1_Configuration_File.ini' File used in this recipe will attempt to install
#                     SQL on the 'F:\' Drive of the Target Host. 
#

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
                $Install_SQL = ./Setup.exe /q /ACTION=Install /SQLSVCPASSWORD="#{sql_password}" /AGTSVCPASSWORD="#{sql_password}" /ASSVCPASSWORD="#{sql_password}" /ISSVCPASSWORD="#{sql_password}" /SAPWD="#{sql_password}" /RSSVCPASSWORD="#{sql_password}" /IACCEPTSQLSERVERLICENSETERMS /CONFIGURATIONFILE="#{sql_config_file_path}"
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

#restart after
reboot 'now' do
  action :request_reboot
  reason 'Cannot continue Chef run without a reboot.'
end