# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box       = "ubuntu/trusty64"
  config.vm.host_name = "Vagrant2"
  
  config.vm.provision     :shell, :path => "bootstrap.sh"
  config.vm.network       :forwarded_port, guest: 80, host: 8082
  config.vm.synced_folder "~/html", "/var/www/html"
  config.vm.synced_folder "~/Project", "/Project"
  config.vm.network       "private_network", ip: "192.168.50.102"

  config.vm.provider :virtualbox do |vb|
    vb.customize [
        "modifyvm", :id,
        "--memory", "4096",
    ]
    vb.name = "192.168.50.102.xip.io"
  end
end
