:: This example shows you copying and registering the fonts on a remote machine
:: This will copy the fonts and fontreg.exe to remote machine %h% into a folder "c:\temp\fonts", then push to that folder, then execute fontreg.
:: Note, you cant execute fontreg from a different working directory else it wont see the fonts, you must change to that dir first.

:: usage remote_install REMOTE_COMPUTER

:: Param remote host to copy fonts
set h=%1

:: %~dp0* means current script path

xcopy /i /s /y "%~dp0*" "\\%h%\c$\temp\fonts\"
psexec -e \\%h% cmd /c (pushd c:\temp\fonts ^& fontreg.exe /copy)