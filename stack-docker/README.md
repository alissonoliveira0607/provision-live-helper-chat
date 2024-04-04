# Guia de Instalação do LiveHelperChat

Este é um guia completo para configurar e executar a stack do LiveHelperChat usando Docker. 

## Dockerfile

O Dockerfile fornece as instruções para construir a imagem Docker que será usada para executar o ambiente da aplicação. Aqui está uma visão geral das etapas realizadas no Dockerfile:

1. **Base Image**: A imagem base é o CentOS 7.
2. **Instalação de Dependências**: Atualizações do sistema, instalação do repositório Remi PHP 8.1 e instalação de pacotes PHP necessários.
3. **Configuração do Apache**: Copia a configuração do Apache para o diretório de configuração.
4. **Download e Configuração do Live Helper Chat**: Baixa o Live Helper Chat, descompacta e copia para o diretório do Apache.
5. **Permissões de Arquivo**: Atribui permissões corretas aos arquivos do Live Helper Chat.
6. **Exposição da Porta**: Expõe a porta 80 para acessar o Apache.

## docker-compose.yml

O arquivo `docker-compose.yml` define os serviços da stack e suas configurações:

- **web**: Serviço que executa o Apache com o Live Helper Chat.
- **database**: Serviço do MySQL para armazenar os dados da aplicação.

## Dependências
- [Docker Documentation](https://docs.docker.com/)
- [CentOS Documentation](https://www.centos.org/docs/)
- [PHP Documentation](https://www.php.net/docs.php)
- [Apache HTTP Server Documentation](https://httpd.apache.org/docs/)
- [MySQL Documentation](https://dev.mysql.com/doc/)
- [Projeto LiveHelperChat](https://github.com/LiveHelperChat/livehelperchat/releases)
- [DOC Instalação manual do projeto](https://doc.livehelperchat.com/docs/install)

## Ajustes a Serem Realizados

- Certifique-se de configurar corretamente os parâmetros de conexão com o banco de dados no Live Helper Chat.
- Personalize as configurações do Apache conforme necessário para atender aos requisitos específicos do seu aplicativo.
- Considere o uso de variáveis de ambiente ou arquivos de configuração externos para armazenar informações sensíveis, como senhas e chaves de acesso.

## Notas e Observações de Segurança

- Mantenha os serviços e pacotes atualizados regularmente para evitar vulnerabilidades conhecidas.
- Limite o acesso aos serviços apenas aos hosts e portas necessários.
- Utilize senhas fortes e evite o armazenamento de credenciais diretamente no código ou em arquivos não seguros.

## Criação da Rede 'devops'

Certifique-se de criar a rede 'devops' antes de executar o stack. Você pode criá-la executando o seguinte comando:
```bash
docker network create devops
```
Isso garantirá que os serviços 'web' e 'database' possam se comunicar entre si.

## Comandos Úteis

- `docker-compose up -d`: Inicia os serviços definidos no arquivo `docker-compose.yml` em segundo plano.
- `docker-compose down -v`: Para e remove os contêineres definidos no arquivo `docker-compose.yml`.



