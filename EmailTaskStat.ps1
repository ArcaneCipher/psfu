#EmailTaskStat.ps1
#Version 1.0

#Get and email the status of one or two Windows Scheduled Tasks.
#This might not work on 2012 server or below. There is a bug where Get-ScheduledTask might not grab all tasks.
#Use the alt version.


#Set vars to your needs:
$TaskName="x"
$SMTP="smtp.some.server"
$EmailTo="x"
$EmailCC=""
$Subject="$env:computername-Status of task: $TaskName"

#Def Functions
function email {
	Param(
        [String[]] $stat
	)
Process {
Send-MailMessage -to $EmailTo -cc $EmailCC -from $EmailFrom -subject $Subject -body "$stat" -SmtpServer $smtp
}}

 
#Main
$GT = Get-ScheduledTask | ? {($_.taskname -eq $TaskName)} | select TaskName,State | Out-String

foreach ($line in $GT) {
If ($line.state -match "disabled") {"disabled"; $GT; email $GT}
If ($line.state -notmatch "disabled") {"not disabled"; $GT}
}

#Local Log
$GT > Task_Stat_$TaskName.log
