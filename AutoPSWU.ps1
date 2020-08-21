#This script kicks off Windows Updates via the PSWindowsUpdate module.
#This will notify on start, auto-install updates, reboot, and email the summary of what was installed.
#This will make sure the PSWindowsUpdate is installed and up-to-date

#Set the Vars
$EmailTo=""
$EmailFrom=""
$SMTP=""

#PS Module Name
$module = "PSWindowsUpdate"

#Repo
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force

#check, update or install
if (Get-Module -ListAvailable | ? {$_.name -match $module}) {Update-Module $module -force} else {Install-Module $module -force}

#Main
Import-Module $module
Send-MailMessage -from $EmailFrom -to $EmailTo -subject "Windows Update has started on $env:computername" -body $(get-date) -SmtpServer $SMTP
Get-WindowsUpdate -MicrosoftUpdate -AcceptAll -Install -IgnoreUserInput -AutoReboot -SendReport -PSWUSettings @{SmtpServer="$SMTP";From="$EmailFrom";To="$EmailTo";Port=25}
