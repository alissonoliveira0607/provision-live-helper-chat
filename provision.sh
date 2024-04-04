#!/bin/bash
MYSQL_PASSWORD=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c 20)
USER="devops"

# Cria o usuário sysadmin
sudo useradd -m -d /home/sysadmin -s /bin/bash sysadmin

# Atualiza o arquivo sudoers para o usuário
echo "sysadmin ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/sysadmin

# Desabilitando o SELINUX
sudo sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/selinux/config
sudo setenforce 0

# Atualiza os repositórios e pacotes
sudo yum update -y

# Adiciona o repositório do MariaDB
sudo cat <<EOF | sudo tee /etc/yum.repos.d/MariaDB.repo
[mariadb]
name = MariaDB
baseurl = http://yum.mariadb.org/10.6/centos7-amd64
gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
gpgcheck=1
EOF

sudo yum update -y

# Instalação de pacotes necessários
sudo yum install -y epel-release yum-utils http://rpms.remirepo.net/enterprise/remi-release-$(rpm -E '%{rhel}').rpm
sudo yum-config-manager --enable remi-php81
sudo yum update -y

# Instalação de pacotes essenciais
sudo yum install -y curl wget git vim unzip httpd MariaDB-server galera-4 MariaDB-client MariaDB-shared MariaDB-backup MariaDB-common php php-cli php-mysqli php-mysql php-gd php-bcmath php-pdo php-mbstring php-xml

# Inicia e habilita o serviço HTTPD
sudo systemctl start httpd
sudo systemctl enable httpd

# Configura o MySQL
#sudo sh -c "echo 'bind-address = 0.0.0.0' >> /etc/my.cnf"
sudo systemctl start mariadb
sudo systemctl enable mariadb

# Executa a instalação segura do MySQL
# sudo mysql_secure_installation <<EOF
# y
# $MYSQL_PASSWORD
# $MYSQL_PASSWORD
# y
# y
# y
# y
# EOF

# Cria o banco de dados e o usuário no MySQL
sudo mysql -u root <<EOF
CREATE DATABASE IF NOT EXISTS livechatdb;
CREATE USER IF NOT EXISTS '$USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
GRANT ALL PRIVILEGES ON livechatdb.* TO '$USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOF

# Baixa e instala o LiveHelperChat
wget https://github.com/LiveHelperChat/livehelperchat/releases/download/4.34v/4.34v-with-dependencies.zip
unzip 4.34v-with-dependencies.zip

# Configuração do LiveHelperChat
sudo cp -r livehelperchat-master /var/www/html/livehelperchat 
sudo chown -R apache: /var/www/html/livehelperchat
sudo chmod -R 755 /var/www/html/livehelperchat

# Configuração do VirtualHost para o LiveHelperChat
sudo cat <<EOF | sudo tee /etc/httpd/conf.d/livehelperchat.conf
<VirtualHost *:80>
    ServerAdmin admin@your-domain.com
    DocumentRoot "/var/www/html/livehelperchat/lhc_web"
    ServerName your-domain.com
    ErrorLog "/var/log/httpd/livehelperchat-error_log"
    CustomLog "/var/log/httpd/livehelperchat-access_log" combined
</VirtualHost>
EOF

sudo mv /etc/httpd/conf/httpd.conf /etc/httpd/conf/httpd.conf.bkp

# Configuração do arquivo httpd.conf
sudo cat <<EOF | sudo tee /etc/httpd/conf/httpd.conf 
ServerRoot "/etc/httpd"
Listen 80
Include conf.modules.d/*.conf
User apache
Group apache
ServerAdmin root@localhost
<Directory />
    AllowOverride none
    Require all denied
</Directory>
DocumentRoot "/var/www/html"
<Directory "/var/www">
    AllowOverride None
    Require all granted
</Directory>
<Directory "/var/www/html">
    Options Indexes FollowSymLinks
    AllowOverride All
    Require all granted
</Directory>
<IfModule dir_module>
    DirectoryIndex index.html
</IfModule>
<Files ".ht*">
    Require all denied
</Files>
ErrorLog "logs/error_log"
LogLevel warn
<IfModule log_config_module>
    LogFormat "%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\"" combined
    LogFormat "%h %l %u %t \"%r\" %>s %b" common
    <IfModule logio_module>
      LogFormat "%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\" %I %O" combinedio      
    </IfModule>
    CustomLog "logs/access_log" combined
</IfModule>
<IfModule alias_module>
    ScriptAlias /cgi-bin/ "/var/www/cgi-bin/"
</IfModule>
<Directory "/var/www/cgi-bin">
    AllowOverride None
    Options None
    Require all granted
</Directory>
<IfModule mime_module>
    TypesConfig /etc/mime.types
    AddType application/x-compress .Z
    AddType application/x-gzip .gz .tgz
    AddType text/html .shtml
    AddOutputFilter INCLUDES .shtml
</IfModule>
AddDefaultCharset UTF-8
<IfModule mime_magic_module>
    MIMEMagicFile conf/magic
</IfModule>
EnableSendfile on
IncludeOptional conf.d/*.conf
EOF

IP=$(hostname -I | awk '{print $2}')

echo "Acesse o endereço http://$IP:80"
echo "USUÀRIO DB: $USER"
echo "SENHA DB: $MYSQL_PASSWORD"

# Reinicia o serviço HTTPD
sudo systemctl restart httpd

# Configura o firewall
echo "Habilitando o serviço do firewalld"
sudo systemctl start firewalld.service
echo "Garantindo regra para acesso HTTP"
sudo firewall-cmd --permanent --zone=public --add-service=http
echo "Garantindo regra para acesso HTTPS"
sudo firewall-cmd --permanent --zone=public --add-service=https
echo "Garantindo regra para MySQL 3306/tcp"
sudo firewall-cmd --permanent --add-port=3306/tcp
sudo firewall-cmd --reload