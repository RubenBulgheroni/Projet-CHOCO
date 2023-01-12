# Créez le message à afficher dans la pop-up
$message = "Voulez-vous exécuter le script ?"

# Créer une fenêtre pop-up avec un bouton Oui/Non
$yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes","Script will be executed."
$no = New-Object System.Management.Automation.Host.ChoiceDescription "&No","Script will not be executed."
$options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no)

# Afficher la pop-up
$result = $host.ui.PromptForChoice("Script Execution", $message, $options, 0)

# Vérifier le choix de l'utilisateur et prendre les mesures appropriées.
if ($result -eq 0) {
    # L'utilisateur a sélectionné "Oui".
    # Exécutez le script ici
    Write-Host "Le script s'est lancé"
}
else {
    # L'utilisateur a sélectionné "Non".
    # Ne pas exécuter le script
    Exit-PSSession
    Write-Host "Le script ne s'est pas lancé"
   break
}