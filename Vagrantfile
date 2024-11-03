# -*- mode: ruby -*-
# vi: set ft=ruby :

########################################
# Variables
########################################
v_base = "debian/bookworm64"
v_name = "hugo"
v_cpu = 4
v_mem = 2048
hugo_version = "0.120.2"

########################################
# Configuration
########################################

Vagrant.configure("2") do |config|
  config.vm.box = v_base
  config.vm.define v_name
  config.vm.hostname = v_name

  config.vm.network "private_network", type: "dhcp"
  config.vm.network "forwarded_port", guest: 1313, host: 1313, protocol: "tcp", auto_correct: true
  config.ssh.extra_args = ["-t", "cd /vagrant; bash --login"]

  config.vm.provider "virtualbox" do |vb|
    vb.gui = false
    vb.name = v_name
    vb.cpus = v_cpu
    vb.memory = v_mem
  end

  config.vm.provision "basics", type: "shell", inline: <<-SHELL
    export DEBIAN_FRONTEND=noninteractive
    apt-get update
    apt-get install -y --no-install-recommends apt-transport-https bash build-essential ca-certificates curl git jq rsync software-properties-common unzip vim wget zip
  SHELL

  config.vm.provision "app-development", type: "shell", env: {"hugo_version" => hugo_version}, inline: <<-SHELL
    export DEBIAN_FRONTEND=noninteractive
    apt-get update
    apt-get install -y --no-install-recommends golang
    cd /tmp
    wget https://github.com/gohugoio/hugo/releases/download/v${hugo_version}/hugo_extended_${hugo_version}_linux-amd64.deb
    dpkg -i hugo_extended_${hugo_version}_linux-amd64.deb
    rm hugo_extended_${hugo_version}_linux-amd64.deb
  SHELL

  config.vm.provision "versions", type: "shell", inline: <<-SHELL
    export DEBIAN_FRONTEND=noninteractive
    hugo version
  SHELL

end
