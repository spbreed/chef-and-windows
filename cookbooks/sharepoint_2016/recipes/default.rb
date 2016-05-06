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
