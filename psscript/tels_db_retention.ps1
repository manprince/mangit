$extensionlist = D:\extensionlist.txt
$outputlog = "D:\output.log"
$max_days = "-200"
$year_backword= "-3"

$curr_date = get-date
$do_date = $curr_date.AddDays($max_days)
write-output $do_date
$dddate = $do_date.ToString("yyyy-MM-dd")
write-output $dddate
Foreach ($extension in (Get-Content "D:\extensionlist.txt" )) {
    $sourcePath = "D:\3CX_Recordings\$extension\"
    $filedate1 = Get-ChildItem -force -path $sourcePath | Select-Object name, CreationTime
     #write-output $filedate1
     #write-output $sourcePath.Fullname
    $files = Get-ChildItem $sourcePath
    Get-ChildItem -Path $sourcePath  | Where-Object -FilterScript {($_.CreationTime -lt $do_date)} | Rename-Item –NewName { $_.name.replace('[','') } 
    $files = Get-ChildItem $sourcePath
    foreach ($file in $files) {
        $filedate2 = $file.CreationTime.ToString('yyyy-MM')
        $filedateday = $file.CreationTime.ToString('dd') #write-output $filedate2
         
        if ($file.CreationTime -lt $do_date) {
#write-output $file
            $targetpath = "\\172.255.160.19\3cxRecording\$filedate2\$filedateday\$extension"
            write-output $file.Fullname
            write-output $file.Fullname | Out-File $outputlog -append
            if (!(Test-Path $targetpath)) {
                New-Item $targetpath -type directory
            }
        
            move-Item -Path $file.fullname -Destination $targetpath
            #write-output $targetpath.fullname | Out-File $outputlog -append
    }
    }
}