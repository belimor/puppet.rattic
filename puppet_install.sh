#!/bin/bash
# Configure network interface: IP, netmask, gateway, dns
# Configure hostname
# Update /etc/hosts if there is no dns records for your server

apt-get update
apt-get install -y wget

# Install Puppet on Ubuntu 14.04
# more information here http://docs.puppetlabs.com/guides/install_puppet/install_debian_ubuntu.html
wget https://apt.puppetlabs.com/puppetlabs-release-trusty.deb
dpkg -i puppetlabs-release-trusty.deb
rm puppetlabs-release-trusty.deb
apt-get update

apt-get install -y puppetmaster
apt-get update
puppet resource package puppetmaster ensure=latest

# add configuration to /etc/puppet.puppet.conf
puppet config set --section main server ${HOSTNAME}
puppet config set --section main ordering manifest
puppet config set --section agent pluginsync true 

# create initial manifest to test puppet
cat > /etc/puppet/manifests/site.pp <<EOF
node '${HOSTNAME}' {
  include my_motd
}
EOF

# create my_motd module wich will update your wellcome message
mkdir /etc/puppet/modules/my_motd
mkdir -p /etc/puppet/modules/my_motd/{files,manifests}

touch /etc/puppet/modules/my_motd/manifests/init.pp
cat > /etc/puppet/modules/my_motd/manifests/init.pp <<EOF
class my_motd {
  case $::hostname {
    ${HOSTNAME} : {
      file { '/etc/motd' :
        ensure => file,
        source => "puppet:///modules/my_motd/\${::hostname}_motd",
      }
    }
    default : {
      file { '/etc/motd' :
        ensure => file,
        source => "puppet:///modules/my_motd/motd",
      }
    }
  }
}
EOF

cat > /etc/puppet/modules/my_motd/files/${HOSTNAME}_motd <<EOF

    .
  .\|/.  ${HOSTNAME}
-------------------------------- 

EOF

cat > > /etc/puppet/modules/my_motd/files/motd <<EOF

    .
  .\|/.  Belimor
--------------------- 

EOF

# run puppet agent to apply manifest
# as a result you should see new welcome message with your hostname in it when log in
puppet agent -t

