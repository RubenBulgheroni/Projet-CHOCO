# Mode d'emploie du script
Write-Host "Voulez-vous afficher le mode d'emploi du script ?" -ForegroundColor Green

$modeemploi = Read-Host "Oui ou Non (1 = oui) (2 = Non)"

switch ($modeemploi) {

    1{  Write-Host "Étape 1 : Vous devez lancer votre scripte en mode administrateur" -ForegroundColor Green
        Write-Host "Étape 2 : Vous devez mettre les fichiers suivants dans le même dossier --> Projetchoco.ps1, Popup.ps1, InstallChoco.ps1, PopupAdmin.ps1" -ForegroundColor Green
        Write-Host "Étape 3 : Si vous souhaitez pérsonnaliser la (3) préconfiguration, vous devez vous rendre sur --> https://community.chocolatey.org/packages" -ForegroundColor Green
        Write-Host "Étape 3.1 : Une fois sur le site de chocolatey vous devez prendre la ligne de commande à côté de votre logiciel puis copié la à la ligne 52 et ajouté les options --force -y -d " -ForegroundColor Green
        Start-Sleep -Seconds 20
    }
    2{    }
}

# Vérifie que le script est bien lancé en administrateur
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    # Si l'utilisateur n'a pas les privilèges d'administrateur, affiche une boîte de dialogue
    $wsh = New-Object -ComObject WScript.Shell
    $result = $wsh.Popup("Vous devez exécuter ce script en tant qu'administrateur. Appuyez sur OK pour fermer ce script.",0,"Attention",0x1)
    # Ferme le script
    exit
}

# Trouve le script principale et le replace dans le bon répertoire

$filePath1 = Get-ChildItem -Recurse | Where-Object {$_.Name -eq "ProjetChoco.ps1"} | Select-Object -ExpandProperty Directory
$filePath = $filePath1,$filePath2 | Select-Object -Unique
cd $filePath

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

