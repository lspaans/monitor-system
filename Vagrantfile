VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "debian/jessie64"
  config.vm.box_version = "8.2.1"
  config.vm.box_url = "https://atlas.hashicorp.com/debian/boxes/jessie64"

  config.vm.provision "shell", path: "deploy.sh"

  config.vm.network "public_network", ip: "10.7.77.1", bridge: "USB Ethernet"
end
