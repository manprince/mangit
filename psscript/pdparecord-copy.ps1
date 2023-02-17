$Users = Import-Csv -Path "D:\Repository\ansiblelinuxaccount\psscript\pdpainfra9march.csv"     
$outputlog = "D:\Repository\ansiblelinuxaccount\psscript\pdpa$date.txt" 
foreach ($User in $Users)
{
$Attention = $User.'Attention'
$phone = $User.'phonenumber'
$date = $User.'datecall'
#production
# $sourcePath = "D:\3CX_Recordings\$Attention\"
# $targetpath = "D:\pdpascrpit\test\$Attention\"
# #$targetpath = "P:\$Attention\"
# $realpath = "\\172.255.160.19\pdpa\record\$Attention\"
#test
$sourcePath = "D:\Repository\3CX_Recordings\$Attention\"
    $targetpath = "D:\Repository\3CX_Recordings_bk\$Attention\"
$realpath = "\\172.255.160.19\pdpa\record\$Attention\"
Write-Output $Attention
Write-Output $phone
#----example
Get-ChildItem -Path $sourcePath -recurse -Filter "*$phone*" |Rename-Item –NewName { $_.name.replace('[','') } 
    $files = Get-ChildItem $sourcePath -recurse -Filter "*$phone*"

    foreach ($file in $files) {
       if (!(Test-Path $targetpath)) {
        New-Item $targetpath -type directory
    }
     $filedate = $file.LastWriteTime.ToString('yyyy-MM-dd_HHMM')
     $fulltarget = $targetpath+$file
    Write-Output '1filename'$sourcePath$file
        write-Output '2full'$fulltarget
        write-Output "'3reformattt'$targetpath$Attention-$phone-$date.wav"
        # $files | rename-item -NewName ($_.Name -replace '\[', '') 
        # $files | rename-item -NewName ($_.Name -replace '\]', '') 
        
        Copy-Item -Path $sourcePath$file -Destination "$targetpath$Attention-$phone-$date-$filedate.wav" -Recurse;
        write-Output "$targetpath$Attention'_'$phone'_'$date''-$filedate.wav" | Out-File $outputlog -append
}
}