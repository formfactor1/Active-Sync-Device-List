<#
Active Sync Device List
.Description
Collects a list of users that have active sync devices and enumerates the devcie type and last sync time
.How to use
Run on the exchange server. Results are exported to the "$exportpath" location
.Created by
Nathan Studebaker
#>

#Define the export path
$exportpath = "C:\support"

#Set empty string and array for exchange active sync devices
$EASDevices = “”
$AllEASDevices = @()
$EASDevices = “”| select ‘User’,'PrimarySMTPAddress’,'DeviceType’,'DeviceModel’,'DeviceOS’, ‘LastSyncAttemptTime’,'LastSuccessSync’
$EasMailboxes = Get-Mailbox -ResultSize unlimited

#Script logic
foreach ($EASUser in $EasMailboxes) {
$EASDevices.user = $EASUser.displayname
$EASDevices.PrimarySMTPAddress = $EASUser.PrimarySMTPAddress.tostring()
    foreach ($EASUserDevices in Get-ActiveSyncDevice -Mailbox $EasUser.alias) {
    $EASDeviceStatistics = $EASUserDevices | Get-ActiveSyncDeviceStatistics
    $EASDevices.devicetype = $EASUserDevices.devicetype
    $EASDevices.devicemodel = $EASUserDevices.devicemodel
    $EASDevices.deviceos = $EASUserDevices.deviceos
    $EASDevices.lastsyncattempttime = $EASDeviceStatistics.lastsyncattempttime
    $EASDevices.lastsuccesssync = $EASDeviceStatistics.lastsuccesssync
    $AllEASDevices += $EASDevices | select user,primarysmtpaddress,devicetype,devicemodel,deviceos,lastsyncattempttime,lastsuccesssync
    }
    }
$AllEASDevices = $AllEASDevices | sort user
$AllEASDevices
$AllEASDevices | Export-Csv $exportpath\ActiveSyncReport.csv
#End Script