:: ATLAS MMO - SERVERUPDATER by 
:: https://nebelbank.net => https://github.com/NebelRebell
:: https://Moonlight-Gaming.eu => https://github.com/BrutalBirdie
:: Idea from https://arkforum.de/thread/717-ark-windows-server-einrichten-autoupdate/
:: Use at your own risk! 2019

:: Be sure to change the Script Path.

@ECHO off
COLOR 0A

Wmic process where (Commandline like "%%Ocean%%" and name like "%%ShooterGame%%") get ProcessId > E:\Server\Atlas\updatedata\pid.txt

CLS

C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe ". 'E:\Server\Atlas\2_AtlasServerUpdater.ps1'"

:: Use it, if you hav an error
::PAUSE

EXIT