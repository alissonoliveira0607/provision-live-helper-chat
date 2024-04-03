Vagrant.configure("2") do |config|
    config.vm.box = "centos/7"
    config.vm.network "public_network", bridge: "Ethernet"
    
    config.vm.provider "virtualbox" do |vb|
      vb.gui = true
      vb.memory = 4096
      vb.cpus = 2
    end
    
    config.vm.provision "shell", path: "./provision.sh"
  end
  