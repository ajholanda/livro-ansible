# Vagrant

## Private key wrong permissions.

- Problem

```
# Windows
vagrant ssh ansible

vagrant@127.0.0.1: Permission denied (publickey).
```

- Solution

```
# 1. Define the path to your key
$path = "C:\Users\u576372.EXATAS\.vagrant.d\insecure_private_keys\vagrant.key.rsa"

# 2. Reset the permissions to remove inherited rules
icacls.exe $path /reset

# 3. Grant your current user explicit Full Control
icacls.exe $path /grant:r "$($env:username):(F)"

# 4. Remove all inheritance (this is the most important step)
icacls.exe $path /inheritance:r
```

## OpenSSH no host Windows (conexao do Ansible)

O `group_vars/windows.yml` ja espera SSH (`ansible_connection: ssh`,
`ansible_shell_type: cmd`, usuario `Administrador` / senha `segredo`). Mas o
OpenSSH precisa estar instalado e rodando *antes* do Ansible conectar -- a role
`sshserver` so ajusta a regra de firewall, nao consegue instalar o servidor
(precisaria de uma conexao SSH ja funcionando: o problema do ovo e da galinha).

Por isso o bootstrap do OpenSSH fica no provisionamento do Vagrant, que roda via
WinRM durante o `vagrant up`. O `Vagrantfile` chama `provision/windows.ps1`
apenas para a box `windows`, que de forma idempotente:

1. Instala a capacidade `OpenSSH.Server`.
2. Sobe o servico `sshd` (Automatic) e abre a porta 22/TCP no firewall.
3. Mantem o shell padrao em `cmd.exe` (casa com `ansible_shell_type: cmd` --
   nao trocar para PowerShell).
4. Cria/atualiza a conta `Administrador` / `segredo` no grupo Administrators.
5. Garante `PasswordAuthentication yes` no `sshd_config`.

Assim nenhum arquivo do Ansible precisa ser alterado.

- Verificar / testar

```
vagrant up windows                            # boota e faz o bootstrap do OpenSSH
vagrant winrm windows -c "Get-Service sshd"   # confirma que o sshd esta rodando
ansible off1.example.net -m ansible.windows.win_ping
```

