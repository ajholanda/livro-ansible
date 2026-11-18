# AWX — Implantação e Desimplantação

Este documento descreve como gerenciar o AWX no controlador (`ansible`), usando o [AWX Operator](https://github.com/ansible/awx-operator) sobre um cluster [Minikube](https://minikube.sigs.k8s.io/).

A [documentação oficial do AWX](https://ansible.readthedocs.io/projects/awx/en/latest/) deve ser consultada para informações atualizadas sobre instalação e requisitos.

---

## Requisitos mínimos da máquina virtual

| Recurso | Mínimo | Recomendado |
| ------- | ------ | ----------- |
| vCPUs   | 4      | 4           |
| RAM     | 6 GB   | 8 GB        |
| Disco   | 20 GB  | 40 GB       |

> A RAM do host físico deve ser suficiente para suportar a VM com os recursos acima. O mínimo recomendado para o host é **16 GB**.
>
> Ajuste a memória e as CPUs da VM no `Vagrantfile` antes de executar o playbook e recarregue o ambiente com `vagrant reload ansible`.

---

## Versões utilizadas nos testes

| Componente    | Versão |
| ------------- | ------ |
| AWX           | 24.6.1 |
| AWX Operator  | 2.19.1 |
| Minikube      | latest |
| kubectl       | stable |

---

## Mecanismo adotado pelo Minikube

O Minikube utiliza o **driver Docker** (`--vm-driver=docker`), ou seja, o cluster Kubernetes é executado como contêineres Docker dentro da própria máquina virtual, sem a necessidade de virtualização aninhada. O *addon* `ingress` é habilitado na inicialização.

Parâmetros de inicialização:

```
minikube start --cpus=4 --memory=6144 --vm-driver=docker --addons=ingress
```

---

## Configuração de persistência

A instância AWX é criada com persistência de projetos habilitada:

```yaml
spec:
  projects_persistence: true
  projects_storage_size: 8Gi
```

Isso cria um `PersistentVolumeClaim` de 8 GiB para armazenar os projetos Ansible gerenciados pelo AWX.

---

## Implantação

Execute o playbook `awx-setup.yml` a partir da máquina virtual `ansible`:

```bash
ansible-playbook awx-setup.yml
```

A instalação pode levar **15 a 20 minutos** dependendo dos recursos disponíveis. Ao final, o playbook exibirá as informações de acesso.

---

## Endereço de acesso à interface

O AWX fica acessível por dois caminhos:

| Método       | Endereço                          | De onde acessar         |
| ------------ | --------------------------------- | ----------------------- |
| NodePort     | `http://<ip-minikube>:30395`      | Dentro da VM            |
| Port-forward | `http://192.168.56.8:8080`        | Navegador do host       |

Para obter o IP do Minikube:

```bash
sg docker -c 'minikube ip'
```

O port-forward é iniciado automaticamente pelo playbook e encaminha a porta `8080` da VM para o serviço AWX.

---

## Obtenção das credenciais iniciais

O usuário padrão é `admin`. A senha é gerada automaticamente e armazenada em um *Secret* do Kubernetes. Para obtê-la:

```bash
kubectl get secret awx-instance-admin-password \
  -o jsonpath="{.data.password}" \
  -n awx | base64 --decode
```

As credenciais também são exibidas ao final da execução do playbook.

---

## Remoção

Execute o playbook `awx-teardown.yml` para remover todos os componentes:

```bash
ansible-playbook awx-teardown.yml
```

O playbook remove, nesta ordem:

1. Processo de port-forward
2. Instância AWX
3. AWX Operator
4. Namespace `awx`
5. Cluster Minikube
6. Arquivos temporários

Os binários `kubectl` e `minikube` são **preservados** por padrão. Para removê-los também:

```bash
ansible-playbook awx-teardown.yml -e remove_binaries=true
```

> O Docker **não** é removido, pois pode estar em uso por outros serviços.
