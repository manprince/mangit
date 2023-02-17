$server_names = Get-Content "pclist.txt"
Foreach ($server in $server_names) {
    
    Write-Output $server;
    Copy-Item "IDAPI32.CFG" -Destination "\\$server\C$\bde32" -Recurse;
}