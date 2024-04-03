# Guia de Instalação do LiveHelperChat

## Visão Geral
Este guia fornece instruções passo a passo para configurar o LiveHelperChat em uma máquina virtual CentOS 7 usando Vagrant e um script de provisionamento. LiveHelperChat é um chat de suporte ao vivo de código aberto para seu site.

## Pré-requisitos
- Vagrant instalado em seu sistema.
- VirtualBox instalado em seu sistema.
- Compreensão básica da linha de comando do Linux.

## Uso
1. Clone este repositório em sua máquina local.
2. Navegue até o diretório onde o arquivo Vagrantfile está localizado.
3. Substitua o "Ethernet pelo nome da sua interface de rede 'bridge'"
```bash
config.vm.network "public_network", bridge: "Ethernet"
```
4. Execute `vagrant up` para iniciar a máquina virtual.
5. Assim que a VM estiver em execução, acesse o LiveHelperChat via seu navegador da web em `http://<VM_IP>:80` (substitua `<VM_IP>` pelo endereço IP da sua VM).

## Vagrantfile
O arquivo Vagrantfile fornecido configura a máquina virtual CentOS 7 com recursos e configurações de rede necessários. Ele também provisiona a VM com o script `provision.sh` fornecido.

## Script de Provisionamento (provision.sh)
O script de provisionamento realiza as seguintes tarefas:
- Cria um usuário sysadmin e concede privilégios de sudo.
- Desabilita o SELinux.
- Atualiza repositórios e pacotes.
- Adiciona o repositório do MariaDB e instala o servidor MariaDB.
- Instala pacotes essenciais, incluindo Apache, PHP e dependências do LiveHelperChat.
- Configura o host virtual do Apache para o LiveHelperChat.
- Inicia serviços necessários e configura regras de firewall.

## Dependências
- [Vagrant](https://www.vagrantup.com/downloads)
- [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
- [CentOS 7 Vagrant Box](https://app.vagrantup.com/centos/boxes/7)
- [Projeto LiveHelperChat](https://github.com/LiveHelperChat/livehelperchat/releases)
- [DOC Instalação manual do projeto](https://doc.livehelperchat.com/docs/install)

## Comandos Básicos do Vagrant
- `vagrant up`: Inicia a máquina virtual.
- `vagrant ssh`: Conecta-se à máquina virtual via SSH.
- `vagrant halt`: Desliga a máquina virtual.
- `vagrant destroy`: Remove a máquina virtual.

## Notas
- Certifique-se de substituir valores de espaço reservado, como `your-domain.com`, por valores apropriados no script de provisionamento.
- Para ambientes de produção, considere configurar medidas de segurança adicionais e personalizar a instalação de acordo com suas necessidades.
- Consulte a documentação de cada componente de software para opções de configuração avançadas e solução de problemas.
