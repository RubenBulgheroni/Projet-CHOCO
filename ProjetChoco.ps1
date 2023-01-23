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
Write-Host "Option (1) Pour installer Chocolatey" -ForegroundColor Cyan
Write-Host "Option (2) Pour rechercher et installer des logiciels" -ForegroundColor Yellow
Write-Host "Option (3) Pour installer une préconfiguration" -ForegroundColor Green
Write-Host "Option (4) Pour mettre à jour tous les logiciels" -ForegroundColor Magenta
Write-Host "Option (5) " -ForegroundColor Magenta

# Demande à l'utilisateur de choisir une option
$response = Read-Host "Entrez le numéro de l'option"

# Traite la réponse de l'utilisateur en fonction de son choix
switch ($response) {
    1 { Powershell.exe -NoExit .\InstallChoco.ps1 } # Exécute le script InstallChoco.ps1
    2{
        $searchTerm = Read-Host "Entrez le logiciel que vous voulez recherchez"
        $results = choco search $searchTerm
        $i = 1
        foreach ($result in $results) {
            $highlightedResult = $result -replace $searchTerm, ("`e[32m" + $searchTerm + "`e[0m")
            Write-Host "$i. $highlightedResult"
            $i++
        }
        $selectedIndex = Read-Host "Entrez le numéro du logiciel que vous voulez installer"
        $selectedPackage = $results[$selectedIndex - 1]
        choco install $selectedPackage --force -y -d --pre
        }
    
    3 { 
    # Liste des logiciels à installer
    $softwareList = @("Firefox", "7zip", "Google Chrome", "Java JRE 8", "Notepad++")

    # Affichage de la liste des logiciels
    Write-Host "Liste :"
    foreach ($software in $softwareList) {
    Write-Host "- $software"
}

# Demande de confirmation avant installation
    $confirmation = Read-Host "Voulez-vous installer cette préconfiguration? [oui] ou [non]"

    if ($confirmation -eq "oui") {
    # Installation des logiciels
    choco install firefox --force -y -d
    choco install 7zip --force -y -d
    choco install googlechrome --force -y -d
    choco install jre8 --force -y -d
    choco install notepadplusplus.install --force -y -d
}
    }
    4 { choco upgrade all } # Met à jour tous les logiciels installés avec Chocolatey
    5 { 
        
    }
    default { Write-Host "Choix non valide" }
}

