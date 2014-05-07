class rattic {
####################################################################################
### apache
####################################################################################
package { [ 'apache2', 'libapache2-mod-wsgi'] :
  ensure => 'latest',
}
service { 'apache2' :
  ensure  => 'running',
  require => Package['apache2', 'libapache2-mod-wsgi'],
}
file { '/etc/apache2/sites-available/000-default.conf' :
  ensure => 'file',
  owner  => 'root',
  group  => 'root',
  mode 	 => '644',
  source => 'puppet:///modules/rattic/000-default.conf',
}
file { 'my_apache_conf' :
  path   => '/etc/apache2/apache2.conf',
  ensure => 'file',
  owner  => 'root',
  group  => 'root',
  mode   => '644',
  source => 'puppet:///modules/rattic/apache2.conf',
}
file { '/etc/apache2/ssl' :
  ensure => 'directory',
  owner  => 'root',
  group  => 'root',
  mode 	 => '0755',
}
file { '/etc/apache2/ssl/apache.key' :
  ensure => 'file',
  owner  => 'root',
  group  => 'root',
  mode   => '0644',
  source => 'puppet:///modules/rattic/apache.key',
}
file { '/etc/apache2/ssl/apache.crt' :
  ensure => 'file',
  owner  => 'root',
  group  => 'root',
  mode 	 => '0644',
  source => 'puppet:///modules/rattic/apache.crt',
}
file { '/etc/apache2/mods-enabled/rewrite.load' :
  ensure => 'link',
  owner  => 'root',
  group  => 'root',
  mode   => '0644',
  target => '../mods-available/rewrite.load',
}
file { '/etc/apache2/mods-enabled/wsgi.load' :
  ensure => 'link',
  owner  => 'root',
  group  => 'root',
  mode   => '0644',
  target => '../mods-available/wsgi.load',
}
file { '/etc/apache2/mods-enabled/wsgi.conf' :
  ensure => 'link',
  owner  => 'root',
  group  => 'root',
  mode   => '0644',
  target => '../mods-available/wsgi.conf',
}
file { '/etc/apache2/mods-enabled/ssl.load' :
  ensure => 'link',
  owner  => 'root',
  group  => 'root',
  mode   => '0644',
  target => '../mods-available/ssl.load',
}
file { '/etc/apache2/mods-enabled/ssl.conf' :
  ensure => 'link',
  owner  => 'root',
  group  => 'root',
  mode   => '0644',
  target => '../mods-available/ssl.conf',
}

####################################################################################
### other packages 
####################################################################################
package { [	'python',
		'python-pip',
		'python-dev',
		'libxml2-dev',
		'libxslt1-dev',
		'gcc',
		'libmysqlclient-dev',
		'libssl-dev',
		'libldap2-dev',
		'libsasl2-dev'
		] :
	ensure => 'latest',
}
####################################################################################
### pip packages
####################################################################################
package { 'Django'			: ensure => '1.6', 	provider => 'pip',}
package { 'Markdown'			: ensure => '2.4',	provider => 'pip',}
package { 'MySQL-python'		: ensure => '1.2.5',	provider => 'pip',}
package { 'Pillow' 			: ensure => '2.3.1',	provider => 'pip',	require => Package['python-dev'],}
package { 'South' 			: ensure => '0.8.4',	provider => 'pip',}
package { 'django-auth-ldap' 		: ensure => '1.1.8', 	provider => 'pip',}
package { 'django-database-files' 	: ensure => '0.1', 	provider => 'pip',}
package { 'django-otp' 			: ensure => '0.2.6', 	provider => 'pip',}
package { 'django-tastypie' 		: ensure => '0.9.15', 	provider => 'pip',}
package { 'django-two-factor-auth' 	: ensure => '0.5.0', 	provider => 'pip',}
package { 'django-user-sessions' 	: ensure => '0.1.3', 	provider => 'pip',}
package { 'mimeparse' 			: ensure => '0.1.3', 	provider => 'pip',}
package { 'pyasn1' 			: ensure => '0.1.7', 	provider => 'pip',}
package { 'pycrypto' 			: ensure => '2.6', 	provider => 'pip',}
package { 'python-dateutil' 		: ensure => '2.1', 	provider => 'pip',}
package { 'python-ldap' 		: ensure => '2.4.15', 	provider => 'pip', 	require => Package['libsasl2-dev'],}
package { 'python-mimeparse' 		: ensure => '0.1.4', 	provider => 'pip',}
package { 'six' 			: ensure => '1.6.1', 	provider => 'pip',}
package { 'urldecode' 			: ensure => '0.1', 	provider => 'pip',}
package { 'wsgiref' 			: ensure => '0.1.2', 	provider => 'pip',}
package { 'keepassdb' 			: ensure => '0.2.1', 	provider => 'pip',}
package { 'db_backup' 			: ensure => '0.1.3', 	provider => 'pip',}
package { 'boto' 			: ensure => '2.26.1', 	provider => 'pip',}
package { 'lxml' 			: ensure => '3.3.3', 	provider => 'pip',	require => [ 	Package['libxslt1-dev'], Package['libxml2-dev'],]}
package { 'celery' 			: ensure => '3.1.11', 	provider => 'pip',}
package { 'django-celery' 		: ensure => '3.1.10', 	provider => 'pip',}
####################################################################################
### rattic
####################################################################################
file { '/opt/apps' :
 	ensure => 'directory',
 	owner => 'root',
 	group => 'root',
 	mode => '0755',
}
exec { 'wget' :
	command => 'wget https://github.com/tildaslash/RatticWeb/archive/v1.0.1.tar.gz',
	cwd 	=> '/opt/apps',
	creates => '/opt/apps/v1.0.1.tar.gz',
	path    => "/usr/bin/",
	require => File['/opt/apps'],
}
exec { 'extract' :
	command => 'tar -zxvf v1.0.1.tar.gz',
	cwd 	=> '/opt/apps',
	creates => '/opt/apps/RatticWeb-1.0.1',
	path    => "/usr/local/bin/:/bin/",
	require => Exec['wget'],
}
exec { "rename":
	command => "mv /opt/apps/RatticWeb-1.0.1 /opt/apps/RatticWeb",
    	creates => "/opt/apps/RatticWeb",
    	path    => "/usr/local/bin/:/bin/",
    	require => Exec['extract'],
}
file { '/opt/apps/RatticWeb/static' :
	ensure 	=> 'directory',
	owner 	=> 'root',
	group 	=> 'root',
	mode 	=> '0775',
}
file { '/opt/apps/RatticWeb/conf/local.cfg' :
	ensure 	=> 'file',
	owner 	=> 'root',
	group 	=> 'root',
	mode 	=> '644',
	source 	=> 'puppet:///modules/rattic/local.cfg',
}
#####################################################################################
### mysql
#####################################################################################
class { '::mysql::server':
  root_password    => 'qwerty-123',
}
mysql::db { 'RatticDB':
      user     => 'rattic',
      password => 'rattic_password',
      host     => 'localhost',
      grant    => ['ALL'],
    }




}

