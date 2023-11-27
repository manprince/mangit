$max_days = "-90"
$curr_date = get-date
$do_date = $curr_date.AddDays($max_days)
write-output $do_date
$dddate = $do_date.ToString("yyyy-MM-dd")
write-output $dddate
    $sourcePath = "C:\ProgramData\3CX\Instance1\Data\Http\Reports"
    $filedate1 = Get-ChildItem -force -path $sourcePath | Select-Object name, CreationTime
    $files = Get-ChildItem $sourcePath
    Get-ChildItem -Path $sourcePath  | Where-Object -FilterScript {($_.CreationTime -lt $do_date)} | Rename-Item –NewName { $_.name.replace('[','') } 
    $files = Get-ChildItem $sourcePath
    foreach ($file in $files) {
        $filedate2 = $file.CreationTime.ToString('yyyy-MM')
        $filedateday = $file.CreationTime.ToString('dd') #write-output $filedate2
         
        if ($file.CreationTime -lt $do_date) {
            write-output $file
          #  del-item "C:\ProgramData\3CX\Instance1\Data\Http\Reports\$file"

    }
    }