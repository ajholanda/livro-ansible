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

