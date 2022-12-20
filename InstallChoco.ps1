#Installation de chocolatey ci-dessous 
Set-ExecutionPolicy Bypass -Scope Process -Force;
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
#"choco" permet de voir la version actuelle de chocolatey
Choco 