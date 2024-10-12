# Jenkins Installation on Ubuntu 24.04 LTS with Vagrant

This repository contains Bash scripts for installing Jenkins, Nexus, and SonarQube on an Ubuntu server, along with a Vagrant configuration file to create a virtual machine for these services. The setup installs OpenJDK, adds the necessary repositories, and configures the services to run on a private network.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Usage](#usage)
- [Accessing Jenkins](#accessing-jenkins)
- [Accessing Nexus](#accessing-nexus)
- [Accessing SonarQube](#accessing-sonarqube)
- [Initial Admin Passwords](#initial-admin-passwords)
- [Stopping and Starting the Vagrant VM](#stopping-and-starting-the-vagrant-vm)

## Prerequisites

- [Vagrant](https://www.vagrantup.com/downloads) installed on your machine.
- [VirtualBox](https://www.virtualbox.org/wiki/Downloads) installed on your machine.

## Installation

1. **Clone the repository:**

  ```bash
  git clone https://github.com/nulltogeek/ci-using-jenkins-nexus-sonarqube-slack.git
  cd ci-using-jenkins-nexus-sonarqube-slack
  git checkout vm-config
  ```

2. **Run Vagrant:**

  This will set up an Ubuntu VM and install Jenkins, Nexus, and SonarQube.

  ```bash
  vagrant up
  ```

  The `vagrant up` command runs the Vagrant configuration defined in the `Vagrantfile`, which provisions the VM with the necessary packages and configurations for Jenkins, Nexus, and SonarQube.

## Usage

The `jenkins-installation.sh`, `nexus-installation.sh`, and `sonar-installation.sh` scripts perform the following actions:

### Jenkins Installation

1. **Updates the package list.**
2. **Installs required dependencies**: `curl`, `gnupg2`, `ca-certificates`, and `lsb-release`.
3. **Adds the Jenkins GPG key and repository.**
4. **Installs OpenJDK (both version 11 version 17).**
5. **Installs Jenkins.**
6. **Starts the Jenkins service and enables it to start on boot.**
7. **Checks the status of the Jenkins service.**
8. **Installs the following Jenkins plugins**:
   - Maven Integration
   - GitHub Integration
   - Nexus Artifact Uploader
   - SonarQube Scanner
   - Slack Notification
   - Build Timestamp

### Nexus Installation

1. **Downloads and installs Nexus.**
2. **Configures Nexus to run as a service.**
3. **Starts the Nexus service and enables it to start on boot.**
4. **Checks the status of the Nexus service.**

### SonarQube Installation

1. **Downloads and installs SonarQube.**
2. **Configures SonarQube to run as a service.**
3. **Starts the SonarQube service and enables it to start on boot.**
4. **Checks the status of the SonarQube service.**

## Accessing Jenkins

Once the Vagrant VM is up and running, you can access Jenkins by navigating to:

```
http://10.0.0.10:8080
```

## Accessing Nexus

You can access Nexus by navigating to:

```
http://10.0.0.10:8081
```

## Accessing SonarQube

You can access SonarQube by navigating to:

```
http://10.0.0.10:80
```

## Initial Admin Passwords

### Jenkins

The initial admin password for Jenkins can be found in the following file:

```
/var/lib/jenkins/secrets/initialAdminPassword
```

To view the password, you can run the following command after the Vagrant VM is provisioned:

```bash
vagrant ssh -c "cat /var/lib/jenkins/secrets/initialAdminPassword"
```

### Nexus

The initial admin password for Nexus can be found in the following file:

```
/nexus-data/admin.password
```

To view the password, you can run the following command after the Vagrant VM is provisioned:

```bash
vagrant ssh -c "cat /nexus-data/admin.password"
```

### SonarQube

The default credentials for SonarQube are:

- Username: `admin`
- Password: `admin`

## Stopping and Starting the Vagrant VM

- To stop the VM:

  ```bash
  vagrant halt
  ```

- To start the VM again:

  ```bash
  vagrant up
  ```

## Conclusion

This setup allows for quick deployment of Jenkins, Nexus, and SonarQube servers on an Ubuntu VM. Modify the Bash scripts or Vagrant configuration as needed for your specific requirements.

