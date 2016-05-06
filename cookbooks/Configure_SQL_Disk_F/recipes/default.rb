#
# Cookbook Name:: Configure_SQL_Disk_F
# Recipe:: default
#
# Copyright (c) 2015 Ryan Irujo, All Rights Reserved.

# Declaring Variables
drive_letter = "F"

# Creating new Disk Drive for SQL and assigning it to Drive Letter of 'F:\'
powershell_script 'Partition and Format new Drive for SQL Install' do
	code <<-EOH
		$NewSQLDisk = Get-Disk | Where-Object {$_.OperationalStatus -match "Offline"}		
		If ($NewSQLDisk.PartitionStyle -match "RAW")
			{
				Initialize-Disk $NewSQLDisk.Number
				New-Partition -DiskNumber $NewSQLDisk.Number -UseMaximumSize -DriveLetter "#{drive_letter}"
				start-Sleep -Seconds 5
				Format-Volume -DriveLetter "#{drive_letter}" -NewFileSystemLabel "SQL Data" -Confirm:$false
				[System.IO.File]::Create("C:\\Windows\\Temp\\SQL_Disk_F_Created_Successfully.txt")
			}
		If ($NewSQLDisk.PartitionStyle -match "GPT")
			{
				$OriginalDiskNumber = $NewSQLDisk.Number
				$NewSQLDisk | Set-Disk -IsOffline:$false
				$NewSQLDisk | Set-Disk -IsReadOnly:$false
				$NewSQLDisk = Get-Disk | Where-Object {$_.Number -match $OriginalDiskNumber}
				New-Partition -DiskNumber $NewSQLDisk.Number -UseMaximumSize -DriveLetter "#{drive_letter}"
				start-Sleep -Seconds 5
				Format-Volume -DriveLetter "#{drive_letter}" -NewFileSystemLabel "SQL Data" -Confirm:$false
				[System.IO.File]::Create("C:\\Windows\\Temp\\SQL_Disk_F_Created_Successfully.txt")
			}
		EOH
	guard_interpreter :powershell_script
	not_if '($SQL_Drive = Get-Volume | Where-Object {$_.FileSystemLabel -match "SQL Data"}).DriveLetter -match "F"'
end