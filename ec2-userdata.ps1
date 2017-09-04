<powershell>
Write-Output "Running User Data Script"
Write-Host "(host) Running User Data Script"

$ErrorActionPreference = "Stop"

# Self-Signed Certificate
Write-Output "Setting up Certificate for WinRM"
Write-Host "(host) Setting up Certificate for WinRM"

$Certificate = New-SelfSignedCertificate -CertstoreLocation Cert:\LocalMachine\My -DnsName "packer"
New-Item -Path WSMan:\LocalHost\Listener -Transport HTTPS -Address * -CertificateThumbPrint $Certificate.Thumbprint -Force

Write-Output "Setting up  WinRM"
Write-Host "(host) Setting up WinRM"
cmd.exe /c winrm quickconfig -q -transport:https
cmd.exe /c winrm set "winrm/config/service/auth" '@{Basic="true"}'
# Allow more memory since some operations may max this out
cmd.exe /c winrm set "winrm/config/winrs" '@{MaxMemoryPerShellMB="1024"}'

cmd.exe /c netsh firewall add portopening TCP 5986 "Port 5986"
</powershell>