# Bootstrap do OpenSSH Server no host Windows.
#
# Roda durante o `vagrant up` (via WinRM), ANTES do Ansible conectar. Deixa o
# host alcançável por SSH exatamente como o group_vars/windows.yml espera
# (ansible_connection: ssh, ansible_shell_type: cmd, usuario Administrador /
# senha segredo) -- assim nenhum arquivo do Ansible precisa ser alterado.

$ErrorActionPreference = 'Stop'

# 1. Instala a capacidade OpenSSH.Server (idempotente).
$cap = Get-WindowsCapability -Online | Where-Object { $_.Name -like 'OpenSSH.Server*' }
if ($cap -and $cap.State -ne 'Installed') {
    Write-Output "Instalando $($cap.Name)..."
    Add-WindowsCapability -Online -Name $cap.Name | Out-Null
}

# 2. Inicia o sshd e o configura para subir junto com o sistema.
Set-Service -Name sshd -StartupType Automatic
Start-Service sshd

# 3. Firewall: libera a porta 22/TCP de entrada.
if (-not (Get-NetFirewallRule -Name 'sshd' -ErrorAction SilentlyContinue)) {
    New-NetFirewallRule -Name sshd -DisplayName 'OpenSSH Server (sshd)' `
        -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22 | Out-Null
}

# 4. Mantem o shell padrao em cmd.exe para casar com `ansible_shell_type: cmd`.
#    (NAO definir DefaultShell para PowerShell.)
Remove-ItemProperty -Path 'HKLM:\SOFTWARE\OpenSSH' -Name DefaultShell -ErrorAction SilentlyContinue

# 5. Desabilita a politica de complexidade de senha para aceitar a senha simples
#    'segredo' (caso contrario New-LocalUser lanca InvalidPasswordException).
$secCfg = Join-Path $env:TEMP 'secpol.cfg'
secedit /export /cfg $secCfg | Out-Null
(Get-Content $secCfg) `
    -replace '(?m)^PasswordComplexity\s*=.*', 'PasswordComplexity = 0' `
    -replace '(?m)^MinimumPasswordLength\s*=.*', 'MinimumPasswordLength = 0' |
    Set-Content $secCfg
secedit /configure /db "$env:windir\security\local.sdb" /cfg $secCfg /areas SECURITYPOLICY | Out-Null
Remove-Item $secCfg -Force -ErrorAction SilentlyContinue

# 6. Cria/atualiza a conta que o Ansible usa para logar (ansible_user/ansible_password).
$user = 'Administrador'
$pass = ConvertTo-SecureString 'segredo' -AsPlainText -Force
if (Get-LocalUser -Name $user -ErrorAction SilentlyContinue) {
    Set-LocalUser -Name $user -Password $pass
} else {
    New-LocalUser -Name $user -Password $pass -PasswordNeverExpires -AccountNeverExpires | Out-Null
}
Add-LocalGroupMember -Group 'Administrators' -Member $user -ErrorAction SilentlyContinue

# 7. Garante autenticacao por senha habilitada (padrao, mas explicitamos).
$cfg = 'C:\ProgramData\ssh\sshd_config'
if (Test-Path $cfg) {
    (Get-Content $cfg) -replace '^#?PasswordAuthentication.*', 'PasswordAuthentication yes' |
        Set-Content $cfg
    Restart-Service sshd
}

Write-Output 'OpenSSH pronto: Ansible pode conectar por SSH na porta 22.'
