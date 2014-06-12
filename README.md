puppetize-rattic
================

Puppet script to setup Rattic password manager (https://github.com/tildaslash/RatticWeb) on Ubuntu server.

If you need to install puppet server create fil script vile.
change to executable (chmod 740 filename)
copy code from puppet.install.sh to tyour file
run as root or with sudo

create foler /etc/puppet/modules/rattic
extract files from github to /etc/puppet/modules/rattic
modify /etc/puppet/manifests/site.pp
node 'your.hostname.here' {
  include rattic
  }

Require: 		puppetlabs-mysql moduel
To install run: 	puppet module install puppetlabs-mysql
More info here: 	https://forge.puppetlabs.com/puppetlabs/mysql
