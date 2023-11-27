<#	
	.NOTES reference 
	===========================================================================
	 Created on:   	12/13/2018 3:57 PM
	 Created by:   	Bradley Wyatt
	 Filename:     	PSPush_LockedOutUsers.ps1
	===========================================================================
	.DESCRIPTION
		Sends a Teams notification via webhook of a recently locked out user. Set up a scheduled task to trigger on event ID 4740. 
#>

#Rocketchat webhook url
$uri = "https://rocket-it.grouplease.co.th/hooks/PHBjt269aXv9ZSgh8/FQfLfyhaS5ktBMP45C9m4DWHD7ZCiGNnePsWGoYuSwuDoBa6"

#Image on the left hand side, here I have a regular user picture
$ItemImage = 'https://www.grouplease.co.th/wp-content/uploads/2021/04/cropped-logo-gl.png'

$ArrayTable = New-Object 'System.Collections.Generic.List[System.Object]'

$Event = Get-EventLog -LogName Security -InstanceId 4740 | Select-object -First 1
[string]$Item = $Event.Message
$Item.SubString($Item.IndexOf("Caller Computer Name"))
$sMachineName = $Item.SubString($Item.IndexOf("Caller Computer Name"))
$sMachineName = $sMachineName.TrimStart("Caller Computer Name :")
$sMachineName = $sMachineName.TrimEnd("}")
$sMachineName = $sMachineName.Trim()
$sMachineName = $sMachineName.TrimStart("\\")

$RecentLockedOutUser = Search-ADAccount -server domain_gl05.com -LockedOut | Get-ADUser -Properties badpwdcount, lockoutTime, lockedout, emailaddress | Select-Object badpwdcount, lockedout, Name, EmailAddress, SamAccountName, @{ Name = "LockoutTime"; Expression = { ([datetime]::FromFileTime($_.lockoutTime).ToLocalTime()) } } | Sort-Object LockoutTime -Descending | Select-Object -first 1

$RecentLockedOutUser | ForEach-Object {
	
	$Section = @{
		title = "$($_.Name) ID $($_.SamAccountName)"
		text  = "$($_.EmailAddress)"
		textx  = "$($_.Name) account ID $($_.SamAccountName) was locked out on $sMachineName at $(($_.LockoutTime).ToString("hh:mm:ss tt"))"
		activityImage  = $ItemImage
		facts		  = @(
			@{
				name  = 'Lockout Source:'
				value = $sMachineName
			},
			@{
				name  = 'Lock-Out Timestamp:'
				value = $_.LockoutTime.ToString()
			},
			@{
				name  = 'Locked Out:'
				value = $_.lockedout
			},
			@{
				name  = 'Bad Password Count:'
				value = $_.badpwdcount
			},
			@{
				name  = 'SamAccountName:'
				value = $_.SamAccountName
			}
		)
	}
	$ArrayTable.add($section)
}

$body = ConvertTo-Json -Depth 8 @{
	title = "Locked Out User - Notification"
	text  = "$($RecentLockedOutUser.Name) account ID $($RecentLockedOutUser.SamAccountName) got locked out on $sMachineName at $(($RecentLockedOutUser.LockoutTime).ToString("hh:mm:ss tt"))"
	attachments = $ArrayTable
	
}
echo "this is body $body"
Write-Host "Sending lockedout account POST" -ForegroundColor Green
Invoke-RestMethod -uri $uri -Method Post -body $body -ContentType 'application/json'