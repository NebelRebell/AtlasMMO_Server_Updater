# ATLAS MMO - SERVERUPDATER by 
# https://nebelbank.net => https://github.com/NebelRebell
# https://Moonlight-Gaming.eu => https://github.com/BrutalBirdie
# Idea from https://arkforum.de/thread/717-ark-windows-server-einrichten-autoupdate/
# Use at your own risk! 2019
#
# Be sure to change the Script Path.

#Clear Screen
Clear-Host

######################### ATLAS SETUP ####################
#CHANGE ME - Folder where SteamCMD is:
$steamcmdFolder="E:\Server\steamcmd"
#CHANGE ME - Folder for Atlas 
$atlasmmofolder="E:\Server\Atlas\"
#not used anymore as the update is done in this script
#The ID of the App Your Updating
$steamAppID="1006030"

#CHANGE ME -RCON IP (same as the server ip)
$rconIP="136.243.48.175"
#QueryPort=57561
$QueryPort="57561"
#Port
$Port="5761"
#CHANGE ME - RCON Port
$rconPort="27000"
#CHANGE ME - RCON Password
$rconPassword="testadmin"
#OceanCells
$ServerX="0"
$ServerY="0"
#PlayerManagement
$MaxPlayers="50"
$ReservedPlayerSlots="5"

########################### GENERAL SETUP #################
$scriptPath = Split-Path -parent $MyInvocation.MyCommand.Definition
$dataPath = $scriptPath+"\updatedata"
$steamcmdExec = $steamcmdFolder+"\steamcmd.exe"
$steamcmdCache = $steamcmdFolder+"\appcache"
$latestAppInfo = $dataPath+"\latestappinfo.json"
$updateinprogress = $dataPath+"\updateinprogress.dat"
$latestAvailableUpdate = $dataPath+"\latestavailableupdate.txt"
$latestInstalledUpdate = $dataPath+"\latestinstalledupdate.txt"

#Startup arguments for the server
$atlasStartArguments="Ocean?ServerX="+$ServerX+"?ServerY="+$ServerY+"?AltSaveDirectoryName="+$ServerX+$ServerY+"?ServerAdminPassword="+$rconPassword+"?MaxPlayers="+$MaxPlayers+"?ReservedPlayerSlots="+$ReservedPlayerSlots+"?QueryPort="+$QueryPort+"?Port="+$Port+"?SeamlessIP="+$rconIP+" -log -server -NoBattlEye"

# Get Atlas PID since Ark: Survival Evolved Server has the same process name and we don't want to touch Ark: Survival Evolved Server
# & $atlasmmofolder"writepid.bat"
$file = $dataPath+"\pid.txt"
function getPid{
	return Get-Content $file | Select -Index 1
}
$tmppid = getPid

#Without clearing cache app_info_update may return old informations
$clearCache=1



If (Test-Path $updateinprogress) {
 Write-Host Update is already in progress
} else {
 Get-Date | Out-File $updateinprogress
 Write-Host Creating Update-Data Directory
 New-Item -Force -ItemType directory -Path $dataPath
 If ($clearCache) {
 Clear-Host
 Write-Host ""
 Write-Host "Removing Cache Folder..."
 Write-Host ""
 Remove-Item $steamcmdCache -Force -Recurse
 }
 Write-Host "Checking Update-Status..."
 Write-Host ""
 & $steamcmdExec +login anonymous +app_info_update 1 +app_info_print $steamAppID +quit | Out-File $latestAppInfo
 Get-Content $latestAppInfo -RAW | Select-String -pattern '(?m)"public"\s*\{\s*"buildid"\s*"\d{6,}"' -AllMatches | %{$_.matches[0].value} | Select-String -pattern '\d{6,}' -AllMatches | %{$_.matches} | %{$_.value} | Out-File $latestAvailableUpdate

 If (Test-Path $latestInstalledUpdate) {
 $installedVersion = Get-Content $latestInstalledUpdate
 } Else {
 $installedVersion = 0
 }
 $availableVersion = Get-Content $latestAvailableUpdate

 if ($installedVersion -ne $availableVersion) {
 Write-Host ""
 Write-Host Current version: $installedVersion - Latest version: $availableVersion

 #ServerUpdate
 Write-Host ""
 Write-Host "Update Script Initialising..."
 Write-Host ""
 #Atlas Update
 & $steamcmdExec +login anonymous +force_install_dir $atlasmmofolder +app_update $steamAppID +exit

 #Kill outdated running Server
 Stop-Process -Id $tmppid
 
 #restart server
 Write-Host ""
 Write-Host "Restarting Server..."
 & $atlasmmofolder"ShooterGame\Binaries\Win64\ShooterGameServer.exe" $atlasStartArguments


 #update current version
 $availableVersion | Out-File $latestInstalledUpdate


 #remove currently being updated block
 Write-Host ""
 Write-Host "Update Done!"
 Remove-Item $updateinprogress -Force
 } ELSE {
 #remove currently being updated block
 Remove-Item $updateinprogress -Force
 Write-Host ""
 Write-Host Running Latest Version $installedVersion
 } 
}