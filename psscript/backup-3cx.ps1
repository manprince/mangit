$extensionlist = D:\Repository\ansiblelinuxaccount\psscript\extensionlist.txt
function Get-TimeStamp {
    return "[{0:yyyy-MM-dd} {0:HH:mm:ss}]" -f (Get-Date)
}
$max_days = "-5"
$curr_date = get-date
$do_date = $curr_date.AddDays($max_days)
$dddate = $do_date.ToString("yyyy-MM-dd")
$datepath = "D:\Repository\3CX_Recordings_bk\$dddate\"
$dpath = "D:\Repository\3CX_Recordings_bk\$dddate\"
If (!(test-path $dpath)) {
    New-Item -ItemType Directory -Force -Path $dpath
    Write-Output 'created '$datepath' '
}
$outputlog = 'D:\Repository\3CX_Recordings_bk\movelog.txt'
Foreach ($extension in (Get-Content "D:\Repository\ansiblelinuxaccount\psscript\extensionlist.txt" )) {
    $sourcePath = "D:\Repository\3CX_Recordings\$extension\"
    $backuppath = "D:\Repository\3CX_Recordings_bk\$extension\"
    $bpath = "D:\Repository\3CX_Recordings_bk\$extension\"
 

    If (!(test-path $bpath)) {
        New-Item -ItemType Directory -Force -Path $backuppath
    }
    Foreach ($file in (Get-ChildItem -File $sourcePath)) {
        $max_days = "-5"
        $curr_date = get-date
        $do_date = $curr_date.AddDays($max_days)
        
        Write-Output $backuppath.fullname;
        if ($file.LastWriteTime -lt $do_date) {
            #less than
            Move-Item -Path $file.fullname -Destination $datepath
            Foreach ($filedest in (Get-ChildItem -File $datepath)) {
                write-Output "$(Get-TimeStamp) $extension_$datepath$filedest" | Out-File $outputlog -append
            }
        }
        ELSE {
            "not copy " 
            Write-Output $file.fullname;
         
        }
    
    }
}

############################################################################### 
 
###########Define Variables######## 
 # Sender Credentials
$Username = "thanapon@csd.co.th"
$Password = "T@a240628"
$fromaddress = "thanapon@csd.co.th" 
$toaddress = "infra@grouplease.co.th" 
#$bccaddress = "Vikas.sukhija@labtest.com" 
#$CCaddress = "Mahesh.Sharma@labtest.com" 
$Subject = "Backup of  3CX Voice record of $do_date " 
$body = 'check attachment back up logs'
$attachment = "$outputlog" 
$smtpserver = "mail.csd.co.th" 
 
#################################### 
 
$message = new-object System.Net.Mail.MailMessage 
$message.From = $fromaddress 
$message.To.Add($toaddress) 
#$message.CC.Add($CCaddress) 
#$message.Bcc.Add($bccaddress) 
$message.IsBodyHtml = $True 
$message.Subject = $Subject 
$attach = new-object System.Net.Mail.Attachment $attachment
$message.Attachments.Add($attach)
$Message.Body = $body
$smtp = new-object Net.Mail.SmtpClient($smtpserver) 
$Smtp.EnableSsl = $true
$Smtp.Credentials = New-Object System.Net.NetworkCredential($Username,$Password)
#$smtp.Send($message) 
