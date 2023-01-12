# Place le script dans le bon dossier
cd .\projet\

# Vérifie que le script est bien lancé en administrateur
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    # Si l'utilisateur n'a pas les privilèges d'administrateur, affiche une boîte de dialogue
    $wsh = New-Object -ComObject WScript.Shell
    $result = $wsh.Popup("Vous devez exécuter ce script en tant qu'administrateur. Appuyez sur OK pour fermer ce script.",0,"Attention",0x1)
    # Ferme le script
    exit
}

# Demande à l'utilisateur de lancer le script ou non
.\Popup.ps1

# Affiche les options disponibles
Write-host "-------------------------------------------------------------------" -ForegroundColor red
Write-Host "Ecrivez le numéro de l'option en fonction de ce que vous choisissez" -ForegroundColor red
Write-host "-------------------------------------------------------------------" -ForegroundColor red
Write-Host "Option (1) pour installer Chocolatey" -ForegroundColor Cyan
Write-Host "Option (2) pour mettre à jour tous les logiciels" -ForegroundColor Yellow
Write-Host "Option (3) Pour installer une préconfiguration" -ForegroundColor Green
Write-Host "Option (4) Pour installer un logiciel sur un autre pc (Beta)" -ForegroundColor Magenta

# Demande à l'utilisateur de choisir une option
$response = Read-Host "Entrez le numéro de l'option"

# Traite la réponse de l'utilisateur en fonction de son choix
switch ($response) {
    1 { Powershell.exe -NoExit .\InstallChoco.ps1 } # Exécute le script InstallChoco.ps1
    2 { choco upgrade all } # Met à jour tous les logiciels installés avec Chocolatey
    3 { 
        choco install firefox --force -y -d  # Installe Firefox
        choco install 7zip --force -y -d  # Installe 7zip
        choco install googlechrome --force -y -d  # Installe Google Chrome
        choco install jre8 --force -y -d  # Installe Java JRE 8
        choco install notepadplusplus.install --force -y -d  # Installe Notepad++
    }
    4 { 
        $AdresseIP = Read-Host "Entrez l'adresse IP de votre PC :" # Demande l'adresse IP de l'ordinateur cible
        $Logiciel = Read-Host "Que voulez-vous installer ?" # Demande quel logiciel installer
        $session = New-PSSession -ComputerName $AdresseIP  # Crée une session PowerShell distante vers l'ordinateur cible
        Invoke-Command -Session $session -ScriptBlock { choco install $Logiciel }
    }
    default { Write-Host "Choix non valide" }
}

