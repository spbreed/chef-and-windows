#
# Cookbook Name:: sharepoint_2013
# Recipe:: default
#
# Copyright (C) 2016 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#
#

iso_path              = "C:\\Users\\chefadmin\\Downloads\\en_sharepoint_server_2013_with_sp1_x64_dvd_3823428.iso"


#Copy AutoSPINTALLER files directory
remote_directory 'C:\\Windows\\Temp\\SP' do
    source 'SP'
    action :create
 not_if '($SP_Server_Service = (gwmi -class Win32_Service | Where-Object {$_.Name -eq "SPTimerV4"}).Name -eq "SPTimerV4")'
end


# Mount and extract the SP 2013 SP1 ISO.
powershell_script 'Mount and extract SP2013 SP1 ISO' do
        code <<-EOH
            $mount_params = @{ImagePath = "#{iso_path}"; PassThru = $true; ErrorAction = "Ignore"}
            $mount = Mount-DiskImage @mount_params
        if ($mount)
                {
                         $volume = Get-DiskImage -ImagePath $mount.ImagePath | Get-Volume
                         $source = $volume.DriveLetter + ":\*"
                         $folder = 'C:\\Windows\\Temp\\sp\\2013\\SharePoint'
                         $params = @{Path = $source; Destination = $folder; Recurse = $true;}
                         cp @params                       
                        echo "The SP2013 SP1 ISO was mounted and extracted Successfully." > C:\\Windows\\Temp\\_SP2013_Server_SP1_ISO_Mounted_Successfully.txt
                        exit 0;
                }

                else
                {
                        echo "The SP2013 SP1 ISO was unable to be mounted." > C:\\Windows\\Temp\\_SP2013_Server_SP1_ISO_Mount_Failed.txt
                        exit 2;
                }
                EOH
        guard_interpreter :powershell_script
	not_if '($SP_Server_Service = (gwmi -class Win32_Service | Where-Object {$_.Name -eq "SPTimerV4"}).Name -eq "SPTimerV4")'
end

# Installing SP 2013 SP1 Standard.
powershell_script 'Install SP2013 SP1' do
        code <<-EOH
                $SPAuto_install_path = 'C:\\Windows\\Temp\\sp\\AutoSPInstaller'
                cd $SPAuto_install_path\\
                $Install_SP = ./AutoSPInstallerLaunch.bat
                $Install_SP > C:\\Windows\\Temp\\_SP2013_SP1_SP1_Install_Results.txt
                EOH
        guard_interpreter :powershell_script
        not_if '($SP_Server_Service = (gwmi -class Win32_Service | Where-Object {$_.Name -eq "SPTimerV4"}).Name -eq "SPTimerV4")'
end


# Dismounting the SP 2013 SP1 ISO.
powershell_script 'Dismount SP2013 SP1' do
        code <<-EOH
                Dismount-DiskImage -ImagePath "#{iso_path}"
                EOH
        guard_interpreter :powershell_script
        only_if { File.exists?(iso_path)}
end
