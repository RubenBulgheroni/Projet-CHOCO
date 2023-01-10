# Affiche une popup qui demande d'être en Administrateur
.\PopupAdmin.ps1

# Fait une popup qui demande à l'utilisateur de lancer le script ou non 
.\Popup.ps1

Write-host "-------------------------------------------------------------------" -ForegroundColor red
Write-Host "Ecrivez le numéro de l'option en fonction de ce que vous choisissez" -ForegroundColor red
Write-host "-------------------------------------------------------------------" -ForegroundColor red
Write-Host "Option (1) pour installer Chocolatey" -ForegroundColor Cyan
Write-Host "Option (2) pour mettre à jour tous ces logiciels" -ForegroundColor Yellow
Write-Host "Option (3) Pour installer une préconfiguration" -ForegroundColor Green
Write-Host "Option (4) Pour installer un logiciel sur un autre pc" -ForegroundColor Magenta

# Demande à l'utilisateur de choisir une option
$response = Read-Host "Entrez le numéro de l'option"

# Traite la réponse de l'utilisateur en fonction de son choix
switch ($response) {
    1 { Powershell.exe -NoExit .\InstallChoco.ps1 }
    2 { choco upgrade all }
    3 { 
        New-Item -Path "C:\Programmes (x86)" -name "Config1" -ItemType directory -force
        choco install firefox --force -y -d "Config1"
        choco install 7zip --force -y -d "C:\Programmes (x86)\Config1"
        choco install googlechrome --force -y -d "C:\Programmes (x86)\Config1"
        choco install jre8 --force -y -d "C:\Programmes (x86)\Config1"
        choco install notepadplusplus.install --force -y -d "C:\Programmes (x86)\Config1"
    }
    4 { 
        $AdresseIP = Read-Host "Entrez l'adresse ip de votre pc :"
        $Logiciel = Read-Host "Que voulez vous installez ?"
        $session = New-PSSession -ComputerName $AdresseIP  
        Invoke-Command -Session $session -ScriptBlock { choco install $Logiciel }
    }
    default { Write-Host "Choix non valide" }
}
