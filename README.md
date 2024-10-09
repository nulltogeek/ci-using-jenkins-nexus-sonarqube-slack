# Jenkins Installation on Ubuntu with Vagrant

This repository contains a Bash script for installing Jenkins on an Ubuntu server and a Vagrant configuration file to create a virtual machine for Jenkins. The setup installs OpenJDK, adds the Jenkins repository, and configures Jenkins to run on a private network.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Usage](#usage)
- [Accessing Jenkins](#accessing-jenkins)
- [Initial Admin Password](#initial-admin-password)
- [Stopping and Starting the Vagrant VM](#stopping-and-starting-the-vagrant-vm)

## Prerequisites

- [Vagrant](https://www.vagrantup.com/downloads) installed on your machine.
- [VirtualBox](https://www.virtualbox.org/wiki/Downloads) installed on your machine.

## Installation

1. **Clone the repository:**

   ```bash
   git clone https://github.com/nulltogeek/ci-using-jenkins-nexus-sonarqube-slack.git
   cd ci-using-jenkins-nexus-sonarqube-slack
   ```

2. **Run Vagrant:**

   This will set up an Ubuntu VM and install Jenkins.

   ```bash
   vagrant up
   ```

   The `vagrant up` command runs the Vagrant configuration defined in the `Vagrantfile`, which provisions the VM with the necessary packages and configurations for Jenkins.

## Usage

The `jenkins-installation.sh` script performs the following actions:

1. **Updates the package list.**
2. **Installs required dependencies**: `curl`, `gnupg2`, `ca-certificates`, and `lsb-release`.
3. **Adds the Jenkins GPG key and repository.**
4. **Installs OpenJDK (both version 11 version 8 version 17).**
5. **Installs Jenkins.**
6. **Starts the Jenkins service and enables it to start on boot.**
7. **Checks the status of the Jenkins service.**

## Accessing Jenkins

Once the Vagrant VM is up and running, you can access Jenkins by navigating to:

```
http://10.0.0.10:8080
```

## Initial Admin Password

The initial admin password for Jenkins can be found in the following file:

```
/var/lib/jenkins/secrets/initialAdminPassword
```

To view the password, you can run the following command after the Vagrant VM is provisioned:

```bash
vagrant ssh -c "cat /var/lib/jenkins/secrets/initialAdminPassword"
```

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

This setup allows for quick deployment of a Jenkins server on an Ubuntu VM. Modify the Bash script or Vagrant configuration as needed for your specific requirements.
