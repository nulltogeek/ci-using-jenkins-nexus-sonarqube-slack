#!/bin/bash

JENKINS_REPO_URL="https://pkg.jenkins.io/debian-stable"
JENKINS_KEY_URL="https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key"

echo -e "\033[0;34mUpdating package list...\033[0m"
sudo apt update -y

echo -e "\033[0;34mInstalling dependencies...\033[0m"
sudo apt install -y curl gnupg2 ca-certificates lsb-release openjdk-11-jdk maven git wget unzip

sudo update-alternatives --config java

echo -e "\033[0;34mAdding Jenkins repository key...\033[0m"
curl -fsSL $JENKINS_KEY_URL | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null

echo -e "\033[0;34mAdding Jenkins repository...\033[0m"
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] $JENKINS_REPO_URL binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

echo -e "\033[0;34mUpdating package list again...\033[0m"
sudo apt update -y

echo -e "\033[0;34mInstalling Jenkins...\033[0m"
sudo apt install -y jenkins

echo -e "\033[0;34mStarting Jenkins...\033[0m"
sudo systemctl start jenkins

echo -e "\033[0;34mEnabling Jenkins to start on boot...\033[0m"
sudo systemctl enable jenkins

echo -e "\033[0;34mChecking Jenkins status...\033[0m"
sudo systemctl status jenkins

echo -e "\033[0;34mJenkins installed. Access it via http://$JENKINS_IP:$JENKINS_PORT\033[0m"
echo -e "\033[0;34mYou can find the initial Jenkins admin password here: /var/lib/jenkins/secrets/initialAdminPassword\033[0m"
sudo cat /var/lib/jenkins/secrets/initialAdminPassword