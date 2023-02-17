$Users = Import-Csv -Path "D:\pdpascrpit\pdpainfra9march.csv"     
$outputlog = "D:\pdpascrpit\pdpa$date.txt" 
foreach ($User in $Users) {
    $Attention = $User.'Attention'
    $phone = $User.'phonenumber'
    $date = $User.'datecall'
    $contract = $User.'contractno'
    #production
    $outputlog = "D:\pdpascrpit\pdpa$date.txt" 
    $sourcePath = "D:\3CX_Recordings\$Attention\"
    #$targetpath = "D:\pdpascrpit\test\$Attention\"
    $targetpath = "\\172.255.160.19\pdpa\record\$Attention\"
    $realpath = "\\3cxbackup\pdpa\record\$Attention\"
    Write-Output $Attention
    Write-Output $phone
    Write-Output $date
    Get-ChildItem -Path $sourcePath -recurse -Filter "*$phone*" | Rename-Item –NewName { $_.name.replace('[', '') } 
    $files = Get-ChildItem $sourcePath -recurse -Filter "*$phone*"
    foreach ($file in $files) {
        # write-output $sourcePath$file
        if (!(Test-Path $targetpath)) {
            New-Item $targetpath -type directory
        }
        $filedate = $file.LastWriteTime.ToString('yyyy-MM-dd_HHmm')
        $fulltarget = $targetpath + $file
        Write-Output $file.fullname
        write-Output $fulltarget
        write-Output $targetpath$Attention-$phone-$contract-$date-$filedate.wav
        #If (Test-Path $DestinationFile) {
        # $i = 0
        if (Test-Path $sourcePath$file -PathType Leaf) {
            Copy-Item -Path $sourcePath$file -Destination "$targetpath$Attention-$phone-$contract-$date-$filedate.wav" -Recurse
            write-Output "$contract $phone $date $Attention $realpath$Attention-$phone-$contract-$date-$filedate.wav" | Out-File $outputlog -append
        }
        #notwork     
        ELSE {
            write-Output "not copy" 
            Write-Output "$contract $phone $date $Attention 'no_record_found'" | Out-File $outputlog -append;
         
        }
    }
}