[CmdletBinding()]
param(
  [Parameter(Mandatory=$true)]
  [string]$Message
)

$wshell = New-Object -ComObject Wscript.Shell
$result = $wshell.Popup($Message,0,"Bienvenue",4)

if ($result -eq 6) {
  # Lancer le script ici
}