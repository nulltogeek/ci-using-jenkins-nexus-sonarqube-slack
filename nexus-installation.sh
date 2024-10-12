#!/bin/bash

sudo apt update && sudo apt upgrade -y

# Install Java 1.8 (OpenJDK)
sudo apt install openjdk-11-jdk wget -y

# Create directories for Nexus
mkdir -p /opt/nexus/
mkdir -p /tmp/nexus/

# Navigate to temporary directory
cd /tmp/nexus/

# Download Nexus
NEXUSURL="https://download.sonatype.com/nexus/3/latest-unix.tar.gz"
wget $NEXUSURL -O nexus.tar.gz

# Extract the downloaded tar.gz file
EXTOUT=$(tar xzvf nexus.tar.gz)
NEXUSDIR=$(echo $EXTOUT | cut -d '/' -f1)

# Clean up the tar.gz file
rm -rf /tmp/nexus/nexus.tar.gz

# Move Nexus to /opt directory
cp -r /tmp/nexus/* /opt/nexus/
sleep 5

# Create nexus user if it doesn't exist
id -u nexus &>/dev/null || useradd nexus

# Change ownership of Nexus directories
chown -R nexus:nexus /opt/nexus

# Make the Nexus executable
chmod +x /opt/nexus/$NEXUSDIR/bin/nexus

# Create a systemd service file for Nexus
cat <<EOT >/etc/systemd/system/nexus.service
[Unit]
Description=Nexus service
After=network.target

[Service]
Type=forking
LimitNOFILE=65536
ExecStart=/opt/nexus/$NEXUSDIR/bin/nexus start
ExecStop=/opt/nexus/$NEXUSDIR/bin/nexus stop
User=nexus
Restart=on-abort

[Install]
WantedBy=multi-user.target
EOT

# Configure Nexus to run as the nexus user
echo 'run_as_user="nexus"' >/opt/nexus/$NEXUSDIR/bin/nexus.rc

# Reload systemd and start the Nexus service
systemctl daemon-reload
systemctl start nexus
systemctl enable nexus