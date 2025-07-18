# Ansible - exemplos para automação de TI

Este repositório contém material para aprendizagem do [Ansible](https://www.ansible.com/).
O [Vagrant](https://www.vagrantup.com/) é usado para criar os ambientes de controle e controlados.

## Ambiente de execução

Para criar o ambiente de execução devemos:

- Instalar o [Virtual Box](https://www.virtualbox.org/);
- Instalar o [Vagrant](https://www.vagrantup.com/);
- Clonar este [repostório](https://github.com/ajholanda/livro-ansible.git);
- Executar o Vagrant usando o terminal dentro do repositório local:

```
vagrant up
```

- Conectar no *host* controlador (senha=vagrant):
```
vagrant ssh ansible
```
- Entrar no diretório com os exemplos:
```
cd livro/
```
- Executar o *script* sem argumentos para mostrar as opções:
```
bash ./cmds.sh
```

Se quiser testar também para *hosts* com sistema Windows, descomente
a linha com as configurações da máquina virtual com o sistema Windows
no arquivo [Vagrantfile](Vagrantfile) e execute:
```
bash ./cmds.sh c12       # capitulo 12
```

Avisos:

- O arquivo com a máquina virtual do Windows é muito grande e seu
*download* e alguns comandos do Vagrant podem demorar muito dependendo
da configuração de rede e do computador em que as máquinas virtuais estão
sendo executadas.

- Os ambientes do Vagrant foram testados. Porém, problemas
com as máquinas virtuais durante o carregamento (`vagrant up`)
ainda podem ocorrer. A maior parte dos problemas é bem relatada em páginas de
grupos de discussão. Em último caso, a reconstrução das máquinas
virtuais pode solucionar a maior parte dos problemas:

```
vagrant halt
vagrant destroy
vagrant up
```

## Informações complementares

As informações complementares ampliam o conteúdo apresentado no livro,
mas não foram incluídas diretamente em seu texto, por serem
facilmente encontradas por meio de sistemas de busca ou
apresentarem grande variabilidade conforme o sistema operacional
ou a distribuição Linux utilizada.

### Instalação

Os *links* dos guias de instalação dos programas usados no livro são listados a seguir:

- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html);

- [ansible-lint](https://ansible.readthedocs.io/projects/lint/installing/#installing-the-latest-version);

- [Ansible Molecule](https://ansible.readthedocs.io/projects/molecule/installation/);

- [Chocolatey](https://chocolatey.org/install) (Windows);

- [yamllint](https://yamllint.readthedocs.io/en/stable/quickstart.html#installing-yamllint).

### Boas práticas

- Recomendações de [boas práticas para o Ansible](https://redhat-cop.github.io/automation-good-practices/).

## Contribuição

Qualquer contribuição é bem-vinda. Basta abrir uma [solicitação de correção](https://github.com/ajholanda/ansible-automacao-ti/issues) ou enviar a [correção](https://github.com/ajholanda/ansible-automacao-ti/pulls).
