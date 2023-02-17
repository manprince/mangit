remove-computer -ComputerName 'training' -Credential Domain_gl05\thanapons -verbose -Force -passthru -Restart
Add-Computer -ComputerName 'training' -Domain "Domain_gl05.com" -localcredential training\administrator -DomainCredential Domain_gl05\thanapons -verbose -Force -passthru -Restart

Add-Computer -ComputerName '192.168.101.93' -Domain "Domain_gl05.com" -credential Domain_gl05\thanapons -passthru -verbose -Restart
Add-Computer -ComputerName 'training' -Domain "Domain_gl05.com"  -DomainCredential Domain_gl05\thanapons -verbose -Force -passthru -Restart
