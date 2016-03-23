# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.network "forwarded_port", guest: 3000, host: 3000
  config.vm.synced_folder ".", "/vagrant", disabled: true
  config.vm.synced_folder ".", "/home/vagrant/app"



  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
  #   vb.memory = "1024"
  # end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Define a Vagrant Push strategy for pushing to Atlas. Other push strategies
  # such as FTP and Heroku are also available. See the documentation at
  # https://docs.vagrantup.com/v2/push/atlas.html for more information.
  # config.push.define "atlas" do |push|
  #   push.app = "YOUR_ATLAS_USERNAME/YOUR_APPLICATION_NAME"
  # end

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.

  config.vm.provision "shell", privileged: true, inline: <<-SHELL
     apt-get -y update
     apt-get -y install build-essential
     apt-get -y install zlib1g-dev git-core nodejs

     # Install Apache and MySQL
     apt-get install -y apache2
     debconf-set-selections <<< 'mysql-server-5.5 mysql-server/root_password password root'
     debconf-set-selections <<< 'mysql-server-5.5 mysql-server/root_password_again password root'
     apt-get -y install mysql-server mysql-client libmysqlclient-dev

     apt-get install -y autoconf bison build-essential libssl-dev libyaml-dev
     apt-get install -y libreadline6-dev zlib1g-dev libncurses5-dev
     apt-get install -y libgdbm3 libgdbm-dev libsqlite3-dev
     apt-get install -y libreadline-dev libssl-dev libffi-dev
     apt-get install -y libxml2-dev libxslt1-dev python-software-properties
  SHELL

  config.vm.provision 'shell', privileged: false, inline: <<-SHELL
     # download rbenv if the directory is missing
     if cd ~/.rbenv && git rev-parse --verify --short=26 HEAD | grep -q $RBENV_VERSION; then
       echo 'rbenv already downloaded at expected revision'
     else
       git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
       cd ~/.rbenv && git checkout $RBENV_VERSION
     fi
     # download ruby-build if the directory is missing
     if cd ~/.rbenv/plugins/ruby-build && git rev-parse --verify --short=26 HEAD | grep -q $RBBUILD_VERSION; then
       echo 'ruby-build already downloaded at expected revision'
     else
       git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
       cd ~/.rbenv/plugins/ruby-build && git checkout $RBBUILD_VERSION
     fi

     RBENV_PATH='export PATH="$HOME/.rbenv/bin:$PATH"'
     if grep -q "$RBENV_PATH" ~/.bash_profile ; then
       echo 'rbenv path already in .bash_profile'
     else
       echo $RBENV_PATH >> ~/.bash_profile
     fi

     RBENV_INIT='eval "$(rbenv init -)"'
     if grep -q "$RBENV_INIT" ~/.bash_profile ; then
       echo 'rbenv init already in .bash_profile'
     else
       echo $RBENV_INIT >> ~/.bash_profile
     fi
  SHELL

  config.vm.provision 'shell', privileged: false, inline: <<-SHELL
    rbenv install 2.1.3
    rbenv global 2.1.3
  SHELL

  config.vm.provision 'shell', privileged: false, inline: <<-SHELL
    echo "gem: --no-document" > ~/.gemrc
    gem install bundler

    echo 'export RAILS_ENV=vagrant' >> ~/.bash_profile
    echo 'cd ~/app' >> ~/.bash_profile

    cd /home/vagrant/app
    bundle install
    RAILS_ENV=vagrant bundle exec rake db:create
    RAILS_ENV=vagrant bundle exec rake db:schema:load
  SHELL

end
