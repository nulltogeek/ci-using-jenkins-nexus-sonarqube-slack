#!/bin/bash

# Function to print messages in blue color
print_blue() {
    echo -e "\e[34m$1\e[0m"
}

print_blue "Updating package lists..."
sudo apt-get update

print_blue "Installing OpenJDK 17..."
# Install OpenJDK 17
sudo apt-get install openjdk-17-jdk -y

print_blue "Verifying Java installation..."
# Verify Java installation
java -version

print_blue "Removing conflicting PostgreSQL packages..."
# Remove conflicting PostgreSQL packages
sudo apt-get remove postgresql-client-common postgresql-common -y

print_blue "Cleaning up package lists..."
# Clean up package lists
sudo apt-get clean
sudo apt-get autoremove -y
sudo apt-get update

print_blue "Installing PostgreSQL..."
# Install PostgreSQL
sudo apt install postgresql postgresql-contrib -y

print_blue "Enabling and starting PostgreSQL service..."
# Enable and start PostgreSQL
sudo systemctl enable postgresql.service
sudo systemctl start postgresql.service
sudo systemctl restart postgresql.service

print_blue "Configuring PostgreSQL user and database for SonarQube..."
# Set PostgreSQL password and create a SonarQube user
sudo -u postgres psql -c "ALTER USER postgres PASSWORD 'admin123';"
sudo -u postgres createuser sonar
sudo -u postgres psql -c "ALTER USER sonar WITH ENCRYPTED PASSWORD 'admin123';"
sudo -u postgres psql -c "CREATE DATABASE sonarqube OWNER sonar;"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE sonarqube TO sonar;"

print_blue "Installing and configuring SonarQube..."
# Install and configure SonarQube
sudo mkdir -p /sonarqube/
cd /sonarqube/
sudo wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-10.7.0.96327.zip
sudo apt-get install unzip -y
sudo unzip sonarqube-10.7.0.96327.zip -d /opt/
sudo mv /opt/sonarqube-10.7.0.96327 /opt/sonarqube
sudo groupadd sonar
sudo useradd -c "SonarQube - User" -d /opt/sonarqube/ -g sonar sonar
sudo chown -R sonar:sonar /opt/sonarqube/
cp /opt/sonarqube/conf/sonar.properties /root/sonar.properties_backup

print_blue "Configuring SonarQube properties..."
cat <<EOT >/opt/sonarqube/conf/sonar.properties
sonar.jdbc.username=sonar
sonar.jdbc.password=admin123
sonar.jdbc.url=jdbc:postgresql://localhost/sonarqube
sonar.web.host=0.0.0.0
sonar.web.port=9000
sonar.web.javaAdditionalOpts=-server
sonar.search.javaOpts=-Xmx512m -Xms512m -XX:+HeapDumpOnOutOfMemoryError
sonar.log.level=INFO
sonar.path.logs=logs
EOT

print_blue "Configuring SonarQube as a service..."
# Configure SonarQube as a service
cat <<EOT >/etc/systemd/system/sonarqube.service
[Unit]
Description=SonarQube service
After=syslog.target network.target

[Service]
Type=forking
ExecStart=/opt/sonarqube/bin/linux-x86-64/sonar.sh start
ExecStop=/opt/sonarqube/bin/linux-x86-64/sonar.sh stop
User=sonar
Group=sonar
Restart=always
LimitNOFILE=65536
LimitNPROC=4096

[Install]
WantedBy=multi-user.target
EOT

print_blue "Reloading systemd and enabling SonarQube service..."
# Reload systemd and enable the SonarQube service
systemctl daemon-reload
systemctl enable sonarqube.service

print_blue "Installing and configuring Nginx as a reverse proxy for SonarQube..."
# Install and configure Nginx as a reverse proxy for SonarQube
sudo apt-get install nginx -y
sudo rm -rf /etc/nginx/sites-enabled/default
sudo rm -rf /etc/nginx/sites-available/default

cat <<EOT >/etc/nginx/sites-available/sonarqube
server {
    listen      80;
    server_name sonarqube.example.com;

    access_log  /var/log/nginx/sonar.access.log;
    error_log   /var/log/nginx/sonar.error.log;

    proxy_buffers 16 64k;
    proxy_buffer_size 128k;

    location / {
        proxy_pass  http://127.0.0.1:9000;
        proxy_next_upstream error timeout invalid_header http_500 http_502 http_503 http_504;
        proxy_redirect off;

        proxy_set_header Host            \$host;
        proxy_set_header X-Real-IP       \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto http;
    }
}
EOT

print_blue "Enabling the SonarQube Nginx site..."
# Enable the SonarQube Nginx site
sudo ln -s /etc/nginx/sites-available/sonarqube /etc/nginx/sites-enabled/sonarqube
sudo systemctl enable nginx.service

print_blue "Configuring firewall to allow necessary ports..."
# Configure firewall to allow necessary ports
sudo apt install ufw -y
sudo ufw allow 80,9000,9001/tcp

