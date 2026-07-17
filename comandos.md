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
2. [Comandos ad-hoc](#capítulo-2--comandos-ad-hoc)
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

Com o ambiente virtual `ansible-venv` ativado, o comando a seguir instala o Ansible, as ferramentas auxiliares e as demais dependências Python listadas no arquivo `requirements.txt`:
```
pip install -r requirements.txt
```
O arquivo `requirements.txt` relaciona todos os pacotes Python necessários para o ambiente de execução do projeto, juntamente com suas versões (quando especificadas).

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

**Observação**: O arquivo /etc/ansible/inventory.py é uma cópia de inventory.py do diretório do livro. Esta alteração é necessária para contornar restrições do Vagrant para execução de arquivos em seus diretórios montados.

### Resumo

Portanto, a abordagem recomendada consiste em criar e ativar um ambiente virtual e, em seguida, instalar todos os pacotes Python necessários ao projeto:

```
python3 -m venv ~/ansible-venv
source ~/ansible-venv/bin/activate
pip install -r requirements.txt
```

O primeiro comando cria o ambiente virtual `ansible-venv`, o segundo o ativa na sessão atual do terminal e o terceiro instala as dependências Python listadas no arquivo `requirements.txt`, incluindo o Ansible e as ferramentas auxiliares utilizadas ao longo do livro.

Esse método também é recomendado para ambientes de produção, pois facilita a padronização das versões do Ansible e de suas dependências, tornando o ambiente de execução reproduzível e isolado da instalação Python gerenciada pelo sistema operacional.

---

## Capítulo 2 — Comandos ad hoc

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

### 2.1 Configuração do Ansible

Versão simplificada do comando quando o `ansible.cfg` já define inventário e elevação de privilégios:

```bash
ansible web.example.net -m package -a "name=apache2"
```

Define o caminho do inventário por variável de ambiente:

```bash
# O comando a seguir copia o arquivo hosts.ini do projeto do livro para
# /srv/ansible/hosts
make /srv/ansible/hosts
# Tome cuidado se for alterar o arquivo hosts.ini do projeto do livro.
# Lembre-se a variável de ambiente tem precedência sobre a definição de
# inventory em ansible.cfg
export ANSIBLE_INVENTORY=/srv/ansible/hosts
# Para desfazer a atribuição à variável de ambiente:
unset ANSIBLE_INVENTORY
```

Lista as variáveis de configuração/ambiente reconhecidas pelo Ansible:

```bash
ansible-config list
```

Inspeciona os valores de configuração efetivamente utilizados:

```
ansible-config dump
```


## Mais comandos _ad hoc_

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

Exibe a documentação completa de um módulo pelo nome completo (FQCN):

```bash
ansible-doc ansible.builtin.copy
```

---

## Capítulo 3 — Playbook

Executa um playbook, lista as tarefas, lista os hosts e inicia a execução a partir de uma tarefa:

```bash
# Cria o arquivo webservers-3.yml que possui o mesmo conteúdo do arquivo
# webservers.yml apresentado no início do Capítulo 3.
make webservers-3.yml
# Executa o ansible-playbook.
ansible-playbook webservers-3.yml
# Lista as tarefas de um playbook sem executá-las.
ansible-playbook webservers-3.yml --list-tasks
# Lista os hosts afetados por um playbook.
ansible-playbook webservers-3.yml --list-hosts
# Inicia a execução a partir de uma tarefa específica, ignorando as anteriores.
ansible-playbook webservers-3.yml --start-at-task "Habilita e inicia o apache"
```

Lista as tarefas de um playbook com múltiplos **plays**:

```bash
ansible-playbook plays.yml --list-tasks
```

### 3.1 Tags

Seleção de tarefas por **tags** (`--tags` seleciona, `--skip-tags` exclui):

```bash
# Cria o arquivo webservers-3_1.yml, que contém o mesmo conteúdo do arquivo
# webservers.yml apresentado na Seção 3.1.
make webservers-3_1.yml
# Seleciona a tag webservers_package.
ansible-playbook webservers-3_1.yml --tags webservers_package
# Exclui a tag webservers_service.
ansible-playbook webservers-3_1.yml --skip-tags webservers_service
# Seleciona múltiplas tags.
ansible-playbook webservers-3_1.yml --tags "webservers_package,webservers_service"
```

Comportamento das **tags** especiais `always`, `never`, `tagged` e `untagged`:

```bash
ansible-playbook tags.yml                       # Execução sem seleção.
ansible-playbook tags.yml --skip-tags always    # Ignora a tag always.
ansible-playbook tags.yml --tags never          # Força a tag never.
ansible-playbook tags.yml --tags debug          # Seleciona outra tag da tarefa marcada com never.
ansible-playbook tags.yml --tags tagged         # Tarefas com pelo menos uma tag.
ansible-playbook tags.yml --tags untagged       # Tarefas sem tag.
```

Lista as **tags** e as tarefas de um playbook:

```bash
ansible-playbook tags.yml --list-tags
ansible-playbook tags.yml --list-tasks
ansible-playbook tags.yml --list-tasks --tags debug,untagged
```

### 3.2 Manipuladores (_handlers_)

Executa playbook que aciona o manipulador `Restart apache` se houver modificação do arquivo de configuração do Apache copiado:

```
ansible-playbook webservers.yml
```

Executa um playbook que aciona manipuladores (*handlers*) via `listen`:

```bash
ansible-playbook listen.yml
```

### 3.3 Erros

Força ocorrência de erro:

```bash
ansible-playbook err.yml --tags err0
```

Tenta listar arquivo que não existe:

```bash
ansible-playbook err.yml --tags err1
```

  Ignora o erro:

```bash
ansible-playbook err.yml --tags err2
```

  Não interpreta `false` como erro:

```bash
ansible-playbook err.yml --tags err3
```

Arquivo deve existir e conteúdo deve estar acessível para o playbook ser bem-sucedido:

```bash
# Gera o arquivo usado no teste de acesso ao conteúdo.
make /etc/ansible/hosts.ini
ansible-playbook err.yml --tags err4
```

Como expressar uma disjunção lógica (operador `or`) em `failed_when`:

```bash
ansible-playbook err.yml --tags err5
```

Verifica o comportamento de `any_errors_fatal`:

```bash
ansible-playbook err.yml --tags err6
```

   Verifica o comportamento de `max_fail_percentage`:

```bash
ansible-playbook err.yml --tags err7
```

Verifica o comportamento de `force_handlers`:

```bash
ansible-playbook err.yml --tags err8
```

Aguarda até que a porta TCP 80 do host esteja acessível antes de prosseguir:

```bash
# Provoca um atraso de 20 segundos para o servidor HTTP entrar no ar.
sudo true && (sleep 20 && sudo python3 -m http.server 80) \
	& ansible-playbook err.yml --tags err9
```

### 3.4 Bloco

Executa exemplo de uso da estrutura `block` - `rescue` - `always`:

```bash
# Instala o servidor MariaDB, que é um requisito para
# a execução do playbook block.yml.
ansible-playbook servers.yml --tags mariadb
ansible-playbook block.yml
```

### 3.5 Inclusão de arquivos de tarefas

Limitações da inclusão dinâmica com `include_tasks` (tarefas/tags incluídas dinamicamente não aparecem e `--start-at-task` não as alcança):

```bash
make include_tasks-3.yml  # Cria a versão semelhante à apresentada no capítulo.
ansible-playbook include_tasks-3.yml --list-tasks
ansible-playbook include_tasks-3.yml --list-tags
ansible-playbook include_tasks-3.yml --start-at-task "Imprime número da tarefa"
```

### 3.6 Controle do fluxo de execução com pre_tasks e post_tasks

Executa um playbook com `pre_tasks`/`post_tasks` e `serial`:

```bash
ansible-playbook pre_tasks_post.yml
```

### 3.7 Idempotência e modos de verificação

Modos de verificação (*check*) e de diferenças (*diff*), que simulam a execução sem alterar os hosts:

```bash
ansible-playbook idempot.yml    # <---- changed
ansible-playbook idempot.yml    # <---- ok
# Apaga o arquivo de configuração para voltar novamente ao estado inicial.
rm /tmp/config.ini
ansible-playbook idempot.yml --check
ansible-playbook idempot.yml --diff
rm /tmp/config.ini
ansible-playbook idempot.yml --check --diff
```

---

## Capítulo 4 — Variáveis

### 4.1 Variáveis especiais
Lista os plugins de conexão disponíveis:

```bash
ansible-doc -t connection -l
```

Coleta os fatos (_facts_) de um host (módulo `setup`):

```bash
ansible -m setup web.example.net
```

Executa playbooks com tarefas condicionadas à família do sistema operacional (variável `ansible_facts['os_family']`):

```bash
ansible-playbook webservers-Debian.yml
ansible-playbook webservers-distro.yml
```


Lista os plugins de cache de fatos disponíveis:

```bash
ansible-doc -t cache -l
```

Define, por variável de ambiente, o plugin de cache de fatos a ser usado:

```bash
export ANSIBLE_CACHE_PLUGIN=jsonfile
```

### 4.2 Variáveis definidas pelo usuário

Define uma variável global na linha de comando com `--extra-vars`:

```bash
ansible-playbook --extra-vars "groupname=webdev" webservers-vars.yml --tags group
```

Demonstra variáveis de host (`host_vars`) e de grupo (`group_vars`):

```bash
ansible-playbook webservers-host_vars.yml
ansible-playbook all-group_vars.yml
```

Demonstra a utilização de `register` para armazenar o resultado de uma execução:

```bash
ansible-playbook register.yml
```

Demonstra o módulo `set_fact`:

```bash
ansible-playbook set_fact.yml
```

### 4.4 Estruturas de dados e de repetição


Como percorrer uma lista simples:

```bash
ansible-playbook webservers-vars.yml --tags users_list
```


Como percorrer uma lista de dicionários:

```bash
ansible-playbook webservers-vars.yml --tags users_dict
```

O filtro `subelements` é utilizado para transformar uma estrutura hierárquica em uma sequência de pares.

```
ansible-playbook subelems.yml
```

O filtro `product` é utilizado para criar os subdiretórios `conf`, `logs` e `data` para cada um dos serviços `web` e `api`:

```bash
ansible-playbook product.yml
```

Mostra o conflito com o laço de repetição externo e sua resolução por meio do `loop_control.loop_var`:

```bash
ansible-playbook loop.yml --tags conflito    # conflito da variável item
ansible-playbook loop.yml --tags controle    # resolução com loop_var
```

Demonstra o uso de `loop_control.{loop_var, index, label}` e a combinação dos três parâmetros:

```bash
ansible-playbook loop.yml --tags users       # laço sobre lista de dicionários
ansible-playbook loop.yml --tags index       # índice do item com index_var
ansible-playbook loop.yml --tags label       # rótulo simplificado com label
ansible-playbook loop.yml --tags combined    # combinação dos parâmetros
```

---
## Capítulo 5 — Roles

Lista recursivamente a estrutura de diretórios de um role:

```bash
tree roles/webserver_debian/
tree roles/webserver/
```

Executa um role aplicado a um host específico, selecionado por *tag*:

```bash
ansible-playbook webserver-role.yml --tags webserver_debian
```

Executa o role `webserver` em todos os hosts do grupo `webservers`:

```bash
ansible-playbook webserver-role.yml
```

Demonstra o comportamento de `include_role`, `import_role` e `meta`:

```bash
# Lista as tags associadas ao role php.
ansible-playbook php.yml --list-tags --tags import
# Realiza a inclusão (include_role) do role webserver.
ansible-playbook php.yml --tags include_webserver
# Realiza a importação (import_role) do role webserver.
ansible-playbook php.yml --tags import_webserver
# Carrega o role webserver como dependência.
ansible-playbook php.yml --tags meta
```

---

## Capítulo 6 — Gabarito (template)

### 6.1 Filtros

Aplicação dos filtros, `mandatory`, `int`, `default` e `join`:

```bash
# Exemplo do uso do filtro mandatory.
ansible-playbook filters.yml --tags filter_mandatory
# Adição do filtro int.
ansible-playbook filters.yml --tags filter_int
# Adição do filtro default.
ansible-playbook filters.yml --tags filter_default
# Exemplo de uso do filtro join.
ansible-playbook filters.yml --tags filter_join
```

### 6.2 Controle de fluxo

Executa somente o role `sssd` para ilustrar a diretiva `if`:

```bash
ansible-playbook desktops.yml --tags sssd
# Conecta no host lab01.
ssh lab01
# Verifica o conteúdo do arquivo de configuração do SSSD após o processamento do gabarito e cópia do conteúdo.
sudo cat /etc/sssd/sssd.conf    # lab01
# Desconecta do lab01.
exit    # lab01
```

Executa as tarefas do role `sshserver` no grupo `workstations` para configurar a diretiva `AllowGroups`:

```bash
ansible-playbook workstations.yml --tags sshserver
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

### 7.1 Criptografia de arquivos

Cria um arquivo criptografado (solicita a senha do cofre e abre o editor):

```bash
ansible-vault create rsyncserver/files/rsyncd.secrets
```

Executa um playbook que usa arquivos criptografados, solicitando a senha do cofre interativamente:

```bash
ansible-playbook servers.yml --ask-vault-pass --limit rsyncservers --tags rsyncserver
```

Executa fornecendo a senha do cofre por um arquivo, evitando a interação:

```bash
ansible-playbook servers.yml --vault-password-file vault.txt \
	--limit rsyncservers --tags rsyncserver
```

Com `vault_password_file` configurado no `ansible.cfg`, a opção pode ser omitida:

```bash
ansible-playbook servers.yml --limit rsyncservers --tags rsyncserver
```

### 7.2 Criptografia de variáveis

Cria um arquivo de variáveis criptografadas para um grupo:

```bash
ansible-vault create group_vars/dbservers/vault.yml
```

Aplica o role que usa as variáveis criptografadas:

```bash
ansible-playbook servers.yml --limit dbservers --tags mariadb
```

Gera, no terminal, um valor criptografado para uma única variável:

```bash
ansible-vault encrypt_string ' senhadodba ' --name 'mariadb_password'
```

### 7.3 Uso de múltiplas senhas

Criptografa um arquivo usando um *vault ID* (`prod`), com a senha solicitada via `prompt` ou lida de um arquivo:

```bash
# Solicita a senha.
ansible-vault encrypt \
	--vault-id prod@prompt \
	--encrypt-vault-id prod \
	roles/sssd/templates/sssd.conf.j2
# Lê a senha a partir de um arquivo.
$ ansible-vault encrypt \
	--vault-id prod@vault-prod.txt \
	--encrypt-vault-id prod \
	roles/sssd/templates/sssd.conf.j2
```

---

## Capítulo 8 — Desenvolvimento de plugins e módulos

### 8.1 Filtros

Executa um playbook que testa um plugin de filtro personalizado:

```bash
ansible-playbook plugin.yml
```

### 8.2 Módulos

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
# Somente um host terá o estado alterado para changed, pois os
# 3 hosts do grupo lab resolvem o nome para a mesma VM Vagrant.
# Esses redirecionamentos visam "economizar" RAM.
ansible-playbook module.yml
```

---

## Capítulo 9 — Ansible Galaxy

### 9.1 Roles

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

### 9.2 Coleções do Ansible

Instala coleções de módulos (exemplos para Windows):

```bash
ansible-galaxy collection install ansible.windows
ansible-galaxy collection install chocolatey.chocolatey
```

Instala todos os roles e coleções declarados em `requirements.yml`:

```bash
ansible-galaxy install -r requirements.yml
```

### 9.3 Execution Environments e ansible-navigator

Constrói um *Execution Environment* (EE) com o `ansible-builder`:

```bash
pipx install ansible-builder
# Como o Docker é executado dentro da VM do Vagrant e o diretório do
# projeto é uma pasta sincronizada, montada a partir do sistema de
# arquivos do host, esse sistema de arquivos apenas emula as permissões
# Unix — e comandos como chmod/chown não funcionam nele, o que provoca
# erros de permissão durante a geração da imagem. Para contornar isso,
# a opção -c /tmp/context gera o contexto de build em /tmp,
# um diretório interno da VM, fora da pasta sincronizada. As demais
# opções têm outros papéis: --no-cache constrói a imagem do zero e
# --prune-images remove as imagens órfãs ao final.
ansible-builder build -t my-ee:1.0 \
	-c /tmp/context \
	--container-runtime docker \
	--prune --no-cache
```

Executa um playbook dentro de um EE com o `ansible-navigator`:

```bash
pipx install ansible-navigator
# Usa o mesmo contexto já criado no comando ansible-builder.
ansible-navigator run site.yml --eei my-ee:1.0 \
	-c /tmp/context \
	--container-engine docker
# Carrega a imagem definida em ansible-navigator.yml.
ansible-navigator run site.yml \
	-c /tmp/context \
	--container-engine docker
```

---

## Capítulo 10 — Depuração

### 10.1 Análise sintática

Instala o `ansible-lint`, que verifica boas práticas e estilo (não faz parte do conjunto padrão):

```bash
pipx install ansible-lint
```

Analisa playbooks com o `ansible-lint`:

```bash
# Detecta erro de aninhamento de parâmetros.
ansible-lint lint_v0.yml
# Exibe violações de boas práticas.
ansible-lint lint_v1.yml
# Usa um arquivo de configuração de regras.
ansible-lint -c lint-config.yml lint_v1.yml
```

Lista todas as regras usadas na validação:

```bash
ansible-lint --list-rules
```

### 10.2 Depuração de tarefas

Habilita o depurador de tarefas por variável de ambiente:

```bash
ANSIBLE_ENABLE_TASK_DEBUGGER=true ansible-playbook webservers.yml
```

Executa um playbook que, ao falhar, aciona o depurador interativo:

```bash
ansible-playbook debugger.yml
```

---

## Capítulo 11 — Testes

### 11.1 Asserções

Executa asserções (`ansible.builtin.assert`) com diferentes verificações, selecionadas por *tag*:

```bash
# A senha deve estar criptografada.
ansible-playbook assert.yml --tags crypto
# Memória mínima antes de instalar o Blender.
ansible-playbook assert.yml --tags blender
# Múltiplos requisitos do sistema.
ansible-playbook assert.yml --tags reqts
```

### 11.2 Testes usando o Ansible Molecule

Instala o Ansible Molecule (e o driver Docker e o Testinfra) no controlador:

```bash
ansible-playbook molecule-setup.yml
```

Cria a estrutura inicial de um cenário de teste do Molecule:

```bash
# Cenário padrão (default).
molecule init scenario
# Cenário com nome específico.
molecule init scenario office
# Exibe a árvore de diretórios.
tree molecule/
```

Ciclo de execução do Molecule por fase:

```bash
# Cria o ambiente (contêiner) do cenário.
molecule create
# Abre um terminal no ambiente criado.
# Seleciona a instância com o Debian.
molecule login  --host instance-debian
# Sai da instância.
root@instance-debian:/$ exit
# Executa o prepare.yml.
molecule prepare
# Aplica o role no contêiner.
molecule converge
# Executa os testes Testinfra.
molecule verify
# Remove o ambiente de testes.
molecule destroy
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
```

### 13.1 Método de conexão

**Os comandos desta seção devem ser executados nos hosts gerenciados com o sistema operacional Windows**

Para instalar o cliente e o servidor OpenSSH no Windows, execute os comandos a seguir em uma janela do PowerShell iniciada com privilégios administrativos:

```powershell
Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
```

Execute os comandos abaixo para iniciar o serviço sshd, configurá-lo para inicialização automática e criar uma regra de firewall permitindo conexões pela porta TCP 22:

```powershell
Start-Service sshd
Set-Service -Name sshd -StartupType 'Automatic'
New-NetFirewallRule `
      -Name 'OpenSSH-Server-In-TCP' `
      -DisplayName 'OpenSSH Server (sshd)' `
      -Enabled True -Direction Inbound -Protocol TCP `
      -Action Allow -LocalPort 22
```

Agenda a verificação da regra de firewall SSH na inicialização:

```bash
$ ansible-playbook desktops.yml --limit windows  --tags sshserver
```

### 13.2 Instalação de programas

Instala a coleção que contém o módulo `win_chocolatey`, responsável por instalar os programas no Windows:

```bash
ansible-galaxy collection install chocolatey.chocolatey
```

Instala o LibreOffice nos hosts do grupo `windows`, que contém as máquinas com o sistema operacional Windows:

```bash
ansible-playbook desktops.yml --limit windows --tags libreoffice
```

### 13.3 Execução de scripts

Obtém as informações do Windows:

```bash
ansible-playbook wininfo.yml
```

### 13.4 Manipulação do Registro do Windows

Desabilita NetBIOS sobre TCP/IP em todas as interfaces:

```bash
ansible-playbook desktops.yml --limit windows --tags netbios
```

### 13.5 Gerenciamento de usuários

Aplica o role para gerenciamento de usuários (`user`) apenas no grupo `windows`:

```bash
ansible-playbook  desktops.yml --limit windows --tags user
```

### 13.6 Agendamento de tarefas

Agenda o desligamento automático diário:

```bash
# IMPORTANTE: adicione o host off1.example.net no grupo lab do arquivo
# de inventário hosts.ini, antes de executar o comando a seguir.
 ansible-playbook desktops.yml --limit windows --tags power
 ```

---

## Capítulo 14 — Ansible Automation Platform e AWX

Implanta o AWX no controlador (laboratório com minikube) por meio do playbook do livro. **Leia o conteúdo do cabeçalho do arquivo `awx-setup.yml` e faça as alterações na configuração do Vagrant (`Vagrantfile`)** antes de executar o comando a seguir.

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

Valida o inventário dinâmico da AWS:

```bash
ansible-inventory -i aws-inventory.aws_ec2.yml --graph
```

Aplica o role `webserver` à instância EC2:
```
ansible-playbook cloud.yml -i aws-inventory.aws_ec2.yml --private-key ~/.aws/web-dev.pem
```
