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
#    AutomaticDelayedStart garante que o adaptador host-only do VirtualBox
#    (192.168.56.x) já esteja ativo antes de o sshd tentar se vincular à porta 22.
#    Com StartupType Automatic há uma corrida entre o sshd e o VBoxService: se o
#    sshd vencer o VBoxService na segunda inicialização, ele fica ouvindo apenas
#    nas interfaces disponíveis naquele momento (loopback + NAT) e nunca passa a
#    aceitar conexões no endereço host-only -- quebrando a conectividade SSH do Ansible.
sc.exe config sshd start= delayed-auto | Out-Null
Start-Service sshd
# Recuperação automática: reinicia o sshd 3× caso ele falhe durante a inicialização
# (5 s → 10 s → 30 s); reseta o contador de falhas após 60 s de serviço estável.
sc.exe failure sshd reset= 60 actions= restart/5000/restart/10000/restart/30000 | Out-Null
# Aplica a recuperação também em paradas não-limpas (exit code ≠ 0).
sc.exe failureflag sshd 1 | Out-Null

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
