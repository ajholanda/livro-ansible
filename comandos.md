# Comandos do livro

Compilação dos comandos de linha de comando apresentados ao longo do livro
*Ansible*, organizados por capítulo e acompanhados de uma breve explicação.
Os comandos foram extraídos do texto principal de cada capítulo (e, quando
úteis, de exercícios e seções de resolução de problemas).

> Convenção: os comandos são apresentados sem o prefixo `$` do *prompt* do
> terminal, para que possam ser copiados e colados diretamente. As quebras de
> linha longas seguem o estilo do livro.

## Sumário

1. [Automação e Ansible](#capítulo-1--automação-e-ansible)
2. [Comandos específicos (ad-hoc)](#capítulo-2--comandos-específicos-ad-hoc)
3. [Playbook](#capítulo-3--playbook)
4. [Variáveis](#capítulo-4--variáveis)
5. [Roles](#capítulo-5--roles)
6. [Gabarito (template)](#capítulo-6--gabarito-template)
7. [Criptografia](#capítulo-7--criptografia)
8. [Desenvolvimento de plugins e módulos](#capítulo-8--desenvolvimento-de-plugins-e-módulos)
9. [Ansible Galaxy](#capítulo-9--ansible-galaxy)
10. [Depuração](#capítulo-10--depuração)
11. [Testes](#capítulo-11--testes)
12. [Estratégias e desempenho](#capítulo-12--estratégias-e-desempenho)
13. [Windows](#capítulo-13--windows)
14. [Ansible Automation Platform e AWX](#capítulo-14--ansible-automation-platform-e-awx)
15. [Casos de uso](#capítulo-15--casos-de-uso)

---

## Capítulo 1 — Automação e Ansible

> Para os impacientes: dentro do diretório do projeto, o comando `make` executa
> toda a configuração do ambiente de uma só vez (ambiente virtual Python,
> Ansible e aplicações auxiliares, coleções, AWS, Docker e ajuste do `.bashrc`).
   Segue a sequências de comandos se optar pela instalação usando o `make`:
   ```
   vagrant@ansible:~/livro$ make
   vagrant@ansible:~/livro$ exit  # Sair da sessão.
   > vagrant ssh ansible          # Entrar na VM para carregar o ambiente virtual.
   vagrant@ansible:~/$ cd livro   # Entrar no diretório do livro.
   ```

> Após a execução dos comandos anteriores, o leitor  pode ir direto aos comandos que usam `ansible-inventory` neste capítulo.

> **Filosofia de instalação.** O livro instala tanto os *aplicativos* quanto as
> *bibliotecas* Python no mesmo **ambiente virtual `ansible-venv`**, usando o
> `pip`:
>
> - **Aplicativos** (programas executados diretamente na linha de comando, como
>   `ansible`, `ansible-lint`, `molecule` ou `ansible-builder`) e **bibliotecas**
>   (pacotes importados pelo Ansible em tempo de execução, como `boto3`,
>   `botocore` ou `passlib`) convivem no mesmo ambiente. Assim, as dependências
>   ficam visíveis ao interpretador Python que o Ansible utiliza — elas precisam
>   residir no mesmo ambiente em que o Ansible roda — e o ambiente virtual isola
>   tudo dos pacotes do sistema, contornando a PEP 668. É essa a abordagem
>   automatizada pelo alvo `make` (ver "Para os impacientes").
> - O **`pipx`** é um **método alternativo**, voltado apenas a *aplicativos*: ele
>   cria um ambiente isolado e dedicado para cada programa, expondo somente os
>   executáveis no `PATH` (`~/.local/bin`). É útil para instalar uma ferramenta
>   de linha de comando sem ativar o `ansible-venv`, mas as bibliotecas
>   importadas pelo Ansible continuam exigindo o `pip` no ambiente virtual.
>
> Em resumo: o método preferido é o `pip` dentro do `ansible-venv`, para tudo
> que se *executa* e tudo que se *importa*; o `pipx` fica como alternativa para
> aplicativos avulsos.

Instala o Ansible como pacote Python via `pip` (dar preferência à instalação dentro do ambiente virtual (`virtualenv`) Python — ver a seguir; o `pipx` é uma alternativa para aplicativos avulsos):

```bash
pip install ansible
```

Para isolar essa instalação dos pacotes do sistema (e contornar a PEP 668), crie um ambiente virtual Python antes de executar o `pip` (**método preferido para instalação de aplicativos e bibliotecas Python**):

```bash
python3 -m venv ~/ansible-venv
```

Ative o ambiente virtual; uma vez ativado, o `pip` passa a instalar os pacotes apenas dentro dele:

```bash
source ~/ansible-venv/bin/activate
```

Instala o Ansible pelo gerenciador de pacotes da família Debian (se preferir instalar para todo o sistema):

```bash
sudo apt install ansible
```

Instala o Ansible pelo gerenciador de pacotes da família Red Hat (se preferir instalar para todo o sistema):

```bash
sudo dnf install ansible
```

Verifica a versão instalada:

```bash
ansible --version
```

Instala o Ansible via `pipx` em ambiente isolado (contorna a PEP 668); `--include-deps` inclui programas auxiliares como `ansible-playbook`, `ansible-galaxy` e `ansible-lint`  (**método alternativo para instalação de aplicativos Python**):

```bash
pipx install --include-deps ansible
```

Injeta, no mesmo ambiente isolado do `ansible`, as aplicações auxiliares de desenvolvimento e teste, mantendo-as disponíveis no `PATH` sem criar ambientes separados:

```bash
pipx inject ansible \
    ansible-builder \
    ansible-lint \
    ansible-navigator \
    molecule pylint \
    yamllint
```

Instala o `pipx` previamente via `apt`:

```bash
sudo apt install pipx
```

Adiciona o diretório `~/.local/bin` ao `PATH` do usuário:

```bash
pipx ensurepath
```

Instala apenas o núcleo de execução (`ansible-core`), sem as coleções da comunidade:

```bash
pipx install ansible-core
```

Exibe, em formato JSON, a saída de um inventário (neste caso, dinâmico):

```bash
ansible-inventory -i /etc/ansible/inventory.py --list
```

Mostra a estrutura hierárquica (grupos e hosts) do inventário:

```bash
ansible-inventory -i /etc/ansible/inventory.py --graph
```

Exibe as variáveis definidas para um host específico:

```bash
ansible-inventory --host w3.example.net
```

**Observação**: O arquivo /etc/ansible/inventory.py é uma cópia de inventory.py do diretório do livro. Esta alteração é necessária para contornar restrições do Vagrant para execução de arquivos em seus diretórios montados.

---

## Capítulo 2 — Comandos específicos (ad-hoc)

Verifica a conectividade com um host usando o módulo `ping` (`-i` indica o inventário, `-m` o módulo):

```bash
ansible w3.example.net -i hosts.ini -m ping
```

Instala o pacote `apache2` em um host; `-a` passa argumentos ao módulo e `--become` ativa a elevação de privilégios:

```bash
ansible web.example.net -i hosts.ini -m package -a "name=apache2 state=present" --become
```

Remove o pacote `apache2` de todos os hosts do grupo `webservers`:

```bash
ansible webservers -i hosts.ini -m package -a "name=apache2 state=absent" --become
```

Exibe a documentação de um módulo:

```bash
ansible-doc package
```

Versão simplificada do comando quando o `ansible.cfg` já define inventário e elevação de privilégios:

```bash
ansible web.example.net -m package -a "name=apache2"
```

Lista as seções e parâmetros do arquivo de configuração do Ansible:

```bash
ansible-config list
```

Demais comandos *ad hoc* frequentes na rotina do administrador:

```bash
# Instala o Git nos hosts do grupo lab
ansible lab -m package -a "name=git"

# Copia um arquivo do controlador para os hosts (módulo copy)
ansible lab -m copy -a "src=/etc/resolv.conf dest=/etc/"
ansible web.example.net -m copy -a "src=files/site.conf dest=/etc/apache2/sites-available"

# Copia do host gerenciado para o controlador (módulo fetch), preservando a origem
ansible web.example.net -m fetch -a "src=/var/log/apache2/access.log dest=/tmp/"
ansible lab -m fetch -a "src=/etc/passwd dest=/tmp/"

# Exibe informações de um arquivo (módulo stat)
ansible w3.example.net -m stat -a "path=/etc/passwd"

# Cria um diretório (módulo file)
ansible lab -m file -a "path=/home/nfs state=directory"

# Cria um link simbólico
ansible web.example.net -m file -a "src=/etc/apache2/sites-available/site.conf dest=/etc/apache2/sites-enabled/site.conf state=link"

# Altera proprietário e permissões de um arquivo
ansible lab -m file -a "path=/etc/shadow owner=root group=shadow mode=0640"

# Remove um arquivo, diretório ou link
ansible devs -m file -a "path=/tmp/texput.log state=absent"

# Executa um comando no shell remoto (módulo command)
ansible servers -m command -a last
```

Coleta e lista todos os *facts* de um host (módulo `setup`):

```bash
ansible web.example.net -m setup
```

Exibe a documentação completa de um módulo pelo nome qualificado (FQCN):

```bash
ansible-doc ansible.builtin.copy
```

---

## Capítulo 3 — Playbook

Executa um playbook (`webserver-3.yml` é a versão inalterada do playbook `webserver.yml` apresentado no início do Capítulo 3):

```bash
make webserver-3.yml  # Cria o arquivo webserver-3.yml
ansible-playbook webserver-3.yml
```

Lista as tarefas de um playbook sem executá-las:

```bash
ansible-playbook webserver-3.yml --list-tasks
```

Lista os hosts afetados por um playbook:

```bash
ansible-playbook webserver-3.yml --list-hosts
```

Inicia a execução a partir de uma tarefa específica, ignorando as anteriores:

```bash
ansible-playbook webserver-3.yml --start-at-task "Habilita e inicia o apache"
```

Lista as tarefas de um playbook com múltiplos *plays*:

```bash
ansible-playbook plays.yml --list-tasks
```

Seleção de tarefas por *tags* (`--tags` seleciona, `--skip-tags` exclui):

```bash
ansible-playbook webserver.yml --tags webserver_package
ansible-playbook webserver.yml --skip-tags webserver_service
ansible-playbook webserver.yml --tags "webserver_package,webserver_service"
```

Comportamento das *tags* especiais `always`, `never`, `tagged` e `untagged`:

```bash
ansible-playbook tags.yml                       # execução sem seleção
ansible-playbook tags.yml --skip-tags always    # ignora a tag always
ansible-playbook tags.yml --tags never          # força a tag never
ansible-playbook tags.yml --tags debug          # seleciona via outra tag da tarefa never
ansible-playbook tags.yml --tags tagged         # tarefas com pelo menos uma tag
ansible-playbook tags.yml --tags untagged       # tarefas sem nenhuma tag
```

Lista as *tags* e as tarefas de um playbook:

```bash
ansible-playbook tags.yml --list-tags
ansible-playbook tags.yml --list-tasks
ansible-playbook tags.yml --list-tasks --tags debug,untagged
```

Executa um playbook que aciona manipuladores (*handlers*) via `listen`:

```bash
ansible-playbook listen.yml
```

Limitações da inclusão dinâmica com `include_tasks` (tarefas/tags incluídas dinamicamente não aparecem e `--start-at-task` não as alcança):

```bash
make include_tasks-3.yml  # Cria a versão semelhante à apresentada no capítulo.
ansible-playbook include_tasks-3.yml --list-tasks
ansible-playbook include_tasks-3.yml --list-tags
ansible-playbook include_tasks-3.yml --start-at-task "Imprime o número da tarefa"
```

Executa um playbook com `pre_tasks`/`post_tasks` e `serial`:

```bash
ansible-playbook pre_tasks_post.yml
```

Modos de verificação (*check*) e de diferenças (*diff*), que simulam a execução sem alterar os hosts:

```bash
ansible-playbook webserver.yml --check
ansible-playbook webserver.yml --diff
ansible-playbook webserver.yml --check --diff
```

Força a execução dos manipuladores mesmo após falhas (citado nos exercícios):

```bash
ansible-playbook webserver.yml --force-handlers
```

---

## Capítulo 4 — Variáveis

Lista os *plugins* de conexão disponíveis:

```bash
ansible-doc -t connection -l
```

Executa playbooks com tarefas condicionadas à família do sistema operacional (variável `ansible_facts['os_family']`):

```bash
ansible-playbook webserver-Debian.yml
ansible-playbook webserver-distro.yml
```

Coleta os *facts* de um host (módulo `setup`):

```bash
ansible -m setup web.example.net
```

Lista os *plugins* de cache de *facts* disponíveis:

```bash
ansible-doc -t cache -l
```

Define, por variável de ambiente, o *plugin* de cache de *facts* a ser usado:

```bash
export ANSIBLE_CACHE_PLUGIN=jsonfile
```

Define uma variável global na linha de comando com `--extra-vars`:

```bash
ansible-playbook --extra-vars "groupname=webdev" webserver-vars.yml
```

Define o caminho do inventário por variável de ambiente:

```bash
export ANSIBLE_INVENTORY=/srv/ansible/hosts
```

Lista as variáveis de configuração/ambiente reconhecidas pelo Ansible:

```bash
ansible-config list
```

Demonstra variáveis de host (`host_vars`) e de grupo (`group_vars`):

```bash
ansible-playbook webserver-host_vars.yml
ansible-playbook all-group_vars.yml
```

Demonstra o uso de `loop` e `loop_control` (cada *tag* carrega um exemplo distinto):

```bash
ansible-playbook loop.yml --tags conflito    # conflito da variável item
ansible-playbook loop.yml --tags controle    # resolução com loop_var
ansible-playbook loop.yml --tags users       # laço sobre lista de dicionários
ansible-playbook loop.yml --tags index       # índice do item com index_var
ansible-playbook loop.yml --tags label       # rótulo simplificado com label
```

Passa uma variável na linha de comando pela forma abreviada `-e`:

```bash
ansible-playbook user.yml -e "username=devops"
```

---

## Capítulo 5 — Roles

Lista recursivamente a estrutura de diretórios de um role:

```bash
tree roles/webserver_debian/
```

Executa um role aplicado a um host específico, selecionado por *tag*:

```bash
ansible-playbook webserver-role.yml --tags webserver_debian
```

Executa o role `webserver` em todos os hosts do grupo `webservers`:

```bash
ansible-playbook webserver-role.yml
```

Aplica um role a grupos distintos, selecionado por *tag* (exemplo do role `chrony`):

```bash
ansible-playbook servers.yml --tags chrony
ansible-playbook workstations.yml --tags chrony
```

Instala roles e coleções declarados no arquivo `requirements.yml`:

```bash
ansible-galaxy install -r requirements.yml
```

Identifica a ordem de execução de roles e suas dependências:

```bash
ansible-playbook servers.yml --tags webserver --list-tasks
ansible-playbook servers.yml --tags webserver
```

---

## Capítulo 6 — Gabarito (template)

Aplica o role `sshserver`, cujo gabarito Jinja2 gera o `sshd_config`:

```bash
ansible-playbook workstations.yml --tags sshserver
```

Verifica o conteúdo gerado por um gabarito diretamente no host (exercício):

```bash
ansible -m command -a "grep override_homedir /etc/sssd/sssd.conf" <grupo>
```

Executa um role em modo de verificação para validar variáveis obrigatórias do gabarito (exercício):

```bash
ansible-playbook webserver-role.yml --check
```

---

## Capítulo 7 — Criptografia

O programa `ansible-vault` recebe a operação a ser executada. As principais operações são:

| Operação | Descrição |
|---|---|
| `create` | Cria um arquivo criptografado. |
| `encrypt` | Criptografa um arquivo existente. |
| `decrypt` | Descriptografa um arquivo. |
| `edit` | Edita o conteúdo de um arquivo criptografado. |
| `view` | Visualiza o conteúdo de um arquivo criptografado. |
| `rekey` | Substitui a senha de um arquivo criptografado. |
| `encrypt_string` | Criptografa uma única variável (*string*). |

Cria um arquivo criptografado (solicita a senha do cofre e abre o editor):

```bash
ansible-vault create rsyncserver/files/rsyncd.secrets
```

Executa um playbook que usa arquivos criptografados, solicitando a senha do cofre interativamente:

```bash
ansible-playbook rsyncservers.yml --ask-vault-pass --limit rsyncservers --tags rsyncserver
```

Executa fornecendo a senha do cofre por um arquivo, evitando a interação:

```bash
ansible-playbook servers.yml --vault-id vault.txt --limit rsyncservers --tags rsyncserver
```

Com `vault_password_file` configurado no `ansible.cfg`, a opção pode ser omitida:

```bash
ansible-playbook servers.yml --limit rsyncservers --tags rsyncserver
```

Cria um arquivo de variáveis criptografadas para um grupo:

```bash
ansible-vault create group_vars/dbservers/vault.yml
```

Aplica o role que usa as variáveis criptografadas:

```bash
ansible-playbook servers.yml --limit dbservers --tags mariadbserver
```

Gera, no terminal, um valor criptografado para uma única variável:

```bash
ansible-vault encrypt_string ' senhadodba ' --name 'mariadb_password'
```

Criptografa um arquivo usando um *vault ID* (`prod`), com a senha solicitada via `prompt` ou lida de um arquivo:

```bash
ansible-vault encrypt --vault-id prod@prompt sssd/templates/sssd.conf.j2 --encrypt-vault-id prod
ansible-vault encrypt --vault-id prod@vault-prod.txt sssd/templates/sssd.conf.j2 --encrypt-vault-id prod
```

---

## Capítulo 8 — Desenvolvimento de plugins e módulos

Executa um playbook que testa um *plugin* de filtro personalizado:

```bash
ansible-playbook plugin.yml
```

Mostra os caminhos de busca de módulos configurados:

```bash
ansible-config dump | grep DEFAULT_MODULE_PATH
```

Define, por variável de ambiente, múltiplos diretórios de módulos (separados por `:`):

```bash
export ANSIBLE_LIBRARY="$HOME/ansible-library:$HOME/.ansible/library"
```

Exibe a documentação de um módulo local, apontando o diretório `library`:

```bash
ANSIBLE_LIBRARY=./library ansible-doc -t module fstab
```

Executa o playbook que utiliza o módulo personalizado:

```bash
ansible-playbook module.yml
```

---

## Capítulo 9 — Ansible Galaxy

Pesquisa roles no Ansible Galaxy pelo terminal:

```bash
ansible-galaxy search x2go
```

Instala um role no diretório de roles do projeto (`--roles-path`):

```bash
ansible-galaxy role install --roles-path ./roles ajholanda.x2goclient
```

Instala e remove o cliente X2Go por meio do playbook, restringindo aos hosts do grupo `ti`:

```bash
ansible-playbook desktops.yml --tags x2goclient --limit ti
ansible-playbook desktops.yml --tags x2goclient --limit ti --extra-vars "x2goclient_state=absent"
```

Exibe a estrutura de diretórios de um role:

```bash
tree roles/ajholanda.x2goclient
```

Instala coleções de módulos (exemplos para Windows):

```bash
ansible-galaxy collection install ansible.windows
ansible-galaxy collection install chocolatey.chocolatey
```

Instala todos os roles e coleções declarados em `requirements.yml`:

```bash
ansible-galaxy install -r requirements.yml
```

Constrói um *Execution Environment* (EE) com o `ansible-builder`:

```bash
pipx install ansible-builder
ansible-builder build -t my-ee:1.0
```

Executa um playbook dentro de um EE com o `ansible-navigator`:

```bash
pipx install ansible-navigator
ansible-navigator run site.yml --eei my-ee:1.0
ansible-navigator run site.yml          # usa a imagem definida em ansible-navigator.yml
```

---

## Capítulo 10 — Depuração

Instala o `ansible-lint`, que verifica boas práticas e estilo (não faz parte do conjunto padrão):

```bash
pip install ansible-lint
```

Analisa playbooks com o `ansible-lint`:

```bash
ansible-lint lint_v0.yml                       # detecta erro de aninhamento de parâmetros
ansible-lint lint_v1.yml                       # exibe violações de boas práticas
ansible-lint -c lint-config.yml lint_v1.yml    # usa um arquivo de configuração de regras
```

Lista todas as regras usadas na validação:

```bash
ansible-lint --list-rules
```

Habilita o depurador de tarefas por variável de ambiente:

```bash
ANSIBLE_ENABLE_TASK_DEBUGGER=true ansible-playbook webserver.yml
```

Executa um playbook que, ao falhar, aciona o depurador interativo:

```bash
ansible-playbook debugger.yml
```

---

## Capítulo 11 — Testes

Executa asserções (`ansible.builtin.assert`) com diferentes verificações, selecionadas por *tag*:

```bash
ansible-playbook assert.yml --tags crypto      # senha deve estar criptografada
ansible-playbook assert.yml --tags blender     # memória mínima antes de instalar
ansible-playbook assert.yml --tags reqts       # múltiplos requisitos do sistema
```

Instala o Ansible Molecule (e o driver Docker e o Testinfra) no controlador:

```bash
ansible-playbook molecule-setup.yml
```

Cria a estrutura inicial de um cenário de teste do Molecule:

```bash
molecule init scenario                         # Cenário default.
molecule init scenario office                  # Cenário com nome específico.
tree molecule/
```

Ciclo de execução do Molecule por fase:

```bash
molecule create      # cria o ambiente (contêiner) do cenário
molecule login       # abre um terminal no ambiente criado
molecule prepare     # executa o prepare.yml
molecule converge    # aplica o role no contêiner
molecule verify      # executa os testes Testinfra
molecule destroy     # remove o ambiente de testes
```

Executa todas as fases do ciclo de vida de uma vez:

```bash
molecule test
```

Repassa argumentos ao `ansible-playbook` (após `--`) e seleciona um cenário (`-s`):

```bash
molecule test -- --limit ubuntu
molecule test -s office
```

---

## Capítulo 12 — Estratégias e desempenho

Ajusta o paralelismo (número de processos simultâneos) com `--forks` (ou `-f`):

```bash
ansible-playbook --forks 20 webserver-role.yml
```

---

## Capítulo 13 — Windows

Instala as coleções necessárias para gerenciar hosts Windows:

```bash
ansible-galaxy collection install ansible.windows
ansible-galaxy collection install chocolatey.chocolatey
```

---

## Capítulo 14 — Ansible Automation Platform e AWX

Implanta o AWX no controlador (laboratório com minikube) por meio do playbook do livro. **Leia o conteúdo do topo do arquivo `awx-setup.yml` e faça as alterações na configuração do Vagrant (`Vagrantfile`)** antes de executar o comando a seguir.

```bash
ansible-playbook awx-setup.yml
```

---

## Capítulo 15 — Casos de uso

Gera o *hash* SHA-512 de uma senha com o filtro `password_hash` (comando *ad hoc*):

```bash
ansible localhost -m debug -a "msg={{ 'senha' | password_hash('sha512') }}"
```

Instala o pacote Python `passlib`, exigido pelo filtro `password_hash`:

```bash
pip install passlib
```

Instala roles do Galaxy, forçando a reinstalação com `--force`:

```bash
ansible-galaxy role install --force --roles-path ./roles ajholanda.googlechrome ajholanda.vscode
```

Aplica roles a desktops, combinando seleção por *tag* e restrição por host/grupo:

```bash
ansible-playbook desktops.yml --tags googlechrome
ansible-playbook desktops.yml --limit lab --tags vscode
ansible-playbook desktops.yml --limit ti1.example.net --tags vscode
```

Aplica o conjunto de roles às estações de trabalho:

```bash
ansible-playbook workstations.yml
```

Provisiona contêineres Docker com o playbook `containers.yml`:

```bash
ansible-playbook containers.yml --tags docker            # instala o Docker
ansible-playbook containers.yml --tags docker_php_apache # contêiner PHP + Apache
ansible-playbook containers.yml --tags docker_postgres   # contêiner PostgreSQL
```

Instala a coleção e os pacotes Python para integração com a AWS:

```bash
ansible-galaxy collection install amazon.aws
pip install awscli boto3 botocore
```

Configura o perfil de conexão com a AWS (interativo): 

```bash
aws configure
```

ou por variáveis de ambiente:
```
export AWS_ACCESS_KEY_ID=****************XMVQ      # Consultar o painel AWS
export AWS_SECRET_ACCESS_KEY=****************OoiY  # para substituir por valores
export AWS_REGION=us-east-1                        # válidos.
```

Provisiona uma instância EC2 na AWS:

```bash
ansible-playbook aws-ec2_provision.yml
```

Valida o inventário dinâmico da AWS e aplica o role `webserver` à instância EC2:

```bash
ansible-inventory -i aws-inventory.aws_ec2.yml --graph
ansible-playbook cloud.yml -i aws-inventory.aws_ec2.yml --private-key ~/.aws/web-dev.pem
```

Verifica o resultado da implantação de contêineres diretamente no host (exercício):

```bash
docker ps
docker network ls
docker inspect
```

Adiciona a chave de um host ao `known_hosts` para corrigir falha de verificação de chave SSH (resolução de problemas):

```bash
ssh-keyscan host >> ~/.ssh/known_hosts
```
