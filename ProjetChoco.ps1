#Vérifie que le script est bien lancé en administrateur
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    $wsh = New-Object -ComObject WScript.Shell
    $result = $wsh.Popup("Vous devez exécuter ce script en tant qu'administrateur. Appuyez sur OK pour fermer ce script.",0,"Attention",0x1)
    exit
}

# Fait une popup qui demande à l'utilisateur de lancer le script ou non 
.\Popup.ps1

Write-host "-------------------------------------------------------------------" -ForegroundColor red
Write-Host "Ecrivez le numéro de l'option en fonction de ce que vous choisissez" -ForegroundColor red
Write-host "-------------------------------------------------------------------" -ForegroundColor red
Write-Host "Option (1) pour installer Chocolatey" -ForegroundColor Cyan
Write-Host "Option (2) pour mettre à jour tous ces logiciels" -ForegroundColor Yellow
Write-Host "Option (3) Pour installer une préconfiguration" -ForegroundColor Green
Write-Host "Option (4) Pour installer un logiciel sur un autre pc (Beta)" -ForegroundColor Magenta

# Demande à l'utilisateur de choisir une option
$response = Read-Host "Entrez le numéro de l'option"
    
# Traite la réponse de l'utilisateur en fonction de son choix
switch ($response) {
    1 { Powershell.exe -NoExit .\InstallChoco.ps1 }
    2 { choco upgrade all }
    3 { 
        choco install firefox --force -y -d 
        choco install 7zip --force -y -d 
        choco install googlechrome --force -y -d 
        choco install jre8 --force -y -d 
        choco install notepadplusplus.install --force -y -d 
    }
    4 { 
        $AdresseIP = Read-Host "Entrez l'adresse ip de votre pc :"
        $Logiciel = Read-Host "Que voulez vous installez ?"
        $session = New-PSSession -ComputerName $AdresseIP  
        Invoke-Command -Session $session -ScriptBlock { choco install $Logiciel }
    }
    default { Write-Host "Choix non valide" }
}
