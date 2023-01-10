# Ajoute les bibliothèques System.Windows.Forms et System.Drawing pour créer des éléments de formulaire tels que des boutons et des étiquettes. 
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

#Crée la fenêtre principale
$form = New-Object System.Windows.Forms.Form
$form.Text = 'Mode Administrateur'
$form.Size = New-Object System.Drawing.Size(300,200)
$form.StartPosition = 'CenterScreen'

#Crée le bouton "OK"
$okButton = New-Object System.Windows.Forms.Button
$okButton.Location = New-Object System.Drawing.Point(75,120)
$okButton.Size = New-Object System.Drawing.Size(75,23)
$okButton.Text = 'OK'
$okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.AcceptButton = $okButton
$form.Controls.Add($okButton)

#Crée le bouton "Annulé"
$cancelButton = New-Object System.Windows.Forms.Button
$cancelButton.Location = New-Object System.Drawing.Point(150,120)
$cancelButton.Size = New-Object System.Drawing.Size(75,23)
$cancelButton.Text = 'Cancel'
$cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$form.CancelButton = $cancelButton
$form.Controls.Add($cancelButton)

#Crée un champ de text 
$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10,20)
$label.Size = New-Object System.Drawing.Size(280,20)
$label.Text = 'Appuyez sur "OK" pour le mode administrateur'
$form.Controls.Add($label)

$form.Topmost = $true

$result = $form.ShowDialog()

#Bloucle qui permet de passé en mode Administrateur
if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
    function Invoke-Elevated {
        [CmdletBinding()]
        param (
            [Parameter(Mandatory=$true)]
            [ScriptBlock]$ScriptBlock
        )
        $psi = New-Object System.Diagnostics.ProcessStartInfo
        $psi.FileName = "powershell"
        $psi.UseShellExecute = $true
        $psi.Verb = "runas"
        $psi.Arguments = "-NoProfile -ExecutionPolicy Bypass -Command ""& $($ScriptBlock.ToString())"""
        [System.Diagnostics.Process]::Start($psi) | Out-Null
    }
}
