Vagrant.configure("2") do |config|

    # Jenkins VM Configuration
    config.vm.define "jenkins-server" do |jenkins|
      jenkins.vm.box = "ubuntu/jammy64"
      jenkins.vm.hostname = "jenkins-server"
      jenkins.vm.network "private_network", ip: "10.0.0.10"
      jenkins.vm.provider "virtualbox" do |vb|
        vb.memory = "2048"
        vb.cpus = 2
      end
      jenkins.vm.provision "shell", path: "jenkins-installation.sh"
    end
  
    # SonarQube VM Configuration
    config.vm.define "sonarqube-server" do |sonarqube|
      sonarqube.vm.box = "ubuntu/jammy64"
      sonarqube.vm.hostname = "sonarqube-server"
      sonarqube.vm.network "private_network", ip: "10.0.0.11"
      sonarqube.vm.provider "virtualbox" do |vb|
        vb.memory = "2048"
        vb.cpus = 2
      end
      sonarqube.vm.provision "shell", path: "sonarqube-installation.sh"
    end
  
    # Nexus VM Configuration
    config.vm.define "nexus-server" do |nexus|
      nexus.vm.box = "ubuntu/jammy64"
      nexus.vm.hostname = "nexus-server"
      nexus.vm.network "private_network", ip: "10.0.0.12"
      nexus.vm.provider "virtualbox" do |vb|
        vb.memory = "2048"
        vb.cpus = 2
      end
      nexus.vm.provision "shell", path: "nexus-installation.sh"
    end
  
  end
  