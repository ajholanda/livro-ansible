# Ansible - exemplos para automação de TI

Este repositório contém material para aprendizagem do [Ansible](https://www.ansible.com/).
O [Vagrant](https://www.vagrantup.com/) é usado para criar os ambientes de controle e controlados.

## Ambiente de execução

Para criar o ambiente de execução devemos:

- Instalar o [Virtual Box](https://www.virtualbox.org/);
- Instalar o [Vagrant](https://www.vagrantup.com/);
- Executar o Vagrant dentro do diretório contendo os exemplos:

```
vagrant up
```

- Conectar no *host* controlador (senha=vagrant):
```
vagrant ssh ansible
```
- Entrar no diretório com os exemplos:
```
cd ansible/
```
- Executar o *script* que executa os comandos:
```
bash ./ansible-cmds.sh
```

Se quiser testar também para *hosts* com sistema Windows, descomente
a linha com as configurações da máquina virtual com o sistema Windows
no arquivo [Vagrantfile](Vagrantfile), repetindo os procedimentos anteriores
com exceção da execução do *script* que ser modificada para

```
bash ./ansible-cmds.sh --windows
```

Aviso: O arquivo com a máquina virtual do Windows é muito grande e seu
*download* e alguns comandos do Vagrant podem demorar muito dependendo
da configuração de rede e do computador em que as máquinas virtuais estão
sendo executadas.

## Contributions

Any contribution is welcome by opening an [issue](https://github.com/ajholanda/ansible-automacao-ti/issues) or sending a [pull request](https://github.com/ajholanda/ansible-automacao-ti/pulls).
