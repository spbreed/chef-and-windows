Previous posts shows how to set up CHEF infrastructure for windows automation, provision Ec2 instances using cloud formation templates , configuring Windows Active Directory and automating SQL 2014 install using CHEF. 

This article covers how to install SharePoint 2016 using CHEF. This cookbook is based on [autospinstaller](https://autospinstaller.com/) by [Brain Lalancette](https://twitter.com/brianlala). For more details about this tool and step by step installs refer my older post [here](http://www.devopsrocks.com/703/autospinstaller-with-sp2016-on-win2016-and-sql2016)


This cookbook will
- Download SharePoint 2016 bits
- Mounts and extracts SharePoint 2016
- Copies AutoSPInstaller files directory to Windows instance
- Uses cookbooks\SharePoint_2016\files\default\SP\2016\AutoSPIntaller\AutoSPInstallerInput.xml to install SharePoint 2016 server
- Dismounts ISO

Change cookbooks\SharePoint_2016\files\default\SP\2016\AutoSPIntaller\AutoSPInstallerInput.xml to suit your custom needs

 ````ruby
#
# Cookbook Name:: sharepoint_2016
# Recipe:: default
#
# Copyright (C) 2016 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#
#


iso_url               = "https://download.microsoft.com/download/0/0/4/004EE264-7043-45BF-99E3-3F74ECAE13E5/officeserver.img"
iso_path              = "C:\\Windows\\Temp\\SPServer_2016.img"


#Download the SQL Server 2014  ISO from a Web Share.
powershell_script 'Download SP 2016 ISO' do
        code <<-EOH
                $Client = New-Object System.Net.WebClient
                $Client.DownloadFile("#{iso_url}", "#{iso_path}")
                EOH
        guard_interpreter :powershell_script
	not_if '($SP_Server_Service = (gwmi -class Win32_Service | Where-Object {$_.Name -eq "SPTimerV4"}).Name -eq "SPTimerV4")'
end

#Copy AutoSPINTALLER files directory
remote_directory 'C:\\Windows\\Temp\\SP' do
    source 'SP'
    action :create
    rights :full_control, 'GSI\\Enterprise Admins'
 not_if '($SP_Server_Service = (gwmi -class Win32_Service | Where-Object {$_.Name -eq "SPTimerV4"}).Name -eq "SPTimerV4")'
end


# Mount and extract the SP 2016  ISO.
powershell_script 'Mount and extract SP2016 ISO' do
        code <<-EOH
            $mount_params = @{ImagePath = "#{iso_path}"; PassThru = $true; ErrorAction = "Ignore"}
            $mount = Mount-DiskImage @mount_params
        if ($mount)
                {
                         $volume = Get-DiskImage -ImagePath $mount.ImagePath | Get-Volume
                         $source = $volume.DriveLetter + ":\*"
                         $folder = 'C:\\Windows\\Temp\\sp\\2016\\SharePoint'
                         $params = @{Path = $source; Destination = $folder; Recurse = $true;}
                         cp @params                       
                        echo "The SP2016  ISO was mounted and extracted Successfully." > C:\\Windows\\Temp\\_SP2016_Server_ISO_Mounted_Successfully.txt
                        exit 0;
                }

                else
                {
                        echo "The SP2016  ISO was unable to be mounted." > C:\\Windows\\Temp\\_SP2016_Server__ISO_Mount_Failed.txt
                        exit 2;
                }
                EOH
        guard_interpreter :powershell_script
	not_if '($SP_Server_Service = (gwmi -class Win32_Service | Where-Object {$_.Name -eq "SPTimerV4"}).Name -eq "SPTimerV4")'
end

# Installing SP 2016  Standard.
powershell_script 'Install SP2016 ' do
        code <<-EOH
                $SPAuto_install_path = 'C:\\Windows\\Temp\\sp\\AutoSPInstaller'
                cd $SPAuto_install_path\\
                $Install_SP = ./AutoSPInstallerLaunch.bat
                $Install_SP > C:\\Windows\\Temp\\_SP2016_Install_Results.txt
                EOH
        guard_interpreter :powershell_script
        not_if '($SP_Server_Service = (gwmi -class Win32_Service | Where-Object {$_.Name -eq "SPTimerV4"}).Name -eq "SPTimerV4")'
end


# Dismounting the SP 2016  ISO.
powershell_script 'Dismount SP2016 ' do
        code <<-EOH
                Dismount-DiskImage -ImagePath "#{iso_path}"
                EOH
        guard_interpreter :powershell_script
        only_if { File.exists?(iso_path)}
end

 
  ````

Now RDP to the server as SharePoint setup admin account, open PowerShell and run 'chef-client' to start the process.

 ![RDP](http://www.devopsrocks.com/mywbblog/wp-content/uploads/2016/04/image022.png)
 ![chef client](http://www.devopsrocks.com/mywbblog/wp-content/uploads/2016/04/image023.png)
 ![SP](http://www.devopsrocks.com/mywbblog/wp-content/uploads/2016/04/image025.png)

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













