class rattic::apache {

  File {
    mode  => '0644',
    owner => 'root',
    group => 'root',
  }
################################ apache install #############################
  package { [ 'apache2', 'libapache2-mod-wsgi'] :
    ensure => 'latest',
  }
  service { 'apache2' :
    ensure  => 'running',
    require => Package['apache2', 'libapache2-mod-wsgi'],
  } 
################################ apache config ##############################
  file { '/etc/apache2/sites-available/000-default.conf' :
    ensure  => 'file',
    source  => 'puppet:///modules/rattic/000-default.conf',
    require => Package['apache2', 'libapache2-mod-wsgi'],
  }
  file { 'my_apache_conf' :
    path    => '/etc/apache2/apache2.conf',
    ensure  => 'file',
    source  => 'puppet:///modules/rattic/apache2.conf',
    require => Package['apache2', 'libapache2-mod-wsgi'],
  }
################################# certificates ##############################
  file { '/etc/apache2/ssl' :
    ensure  => 'directory',
    require => Package['apache2', 'libapache2-mod-wsgi'],
  }
  file { '/etc/apache2/ssl/apache.key' :
    ensure  => 'file',
    source  => 'puppet:///modules/rattic/apache.key',
    require => File['/etc/apache2/ssl'],
  }
  file { '/etc/apache2/ssl/apache.crt' :
    ensure  => 'file',
    source  => 'puppet:///modules/rattic/apache.crt',
    require => File['/etc/apache2/ssl'],
  }
################################# apache modules #############################
  file { '/etc/apache2/mods-enabled/rewrite.load' :
    ensure  => 'link',
    target  => '/etc/apache2/mods-available/rewrite.load',
    require => Package['apache2', 'libapache2-mod-wsgi'],
  } ->
  file { '/etc/apache2/mods-enabled/headers.load' :
    ensure => 'link',
    target => '/etc/apache2/mods-available/headers.load',
  } ->
  file { '/etc/apache2/mods-enabled/wsgi.load' :
    ensure => 'link',
    target => '/etc/apache2/mods-available/wsgi.load',
  } ->
  file { '/etc/apache2/mods-enabled/wsgi.conf' :
    ensure => 'link',
    target => '/etc/apache2/mods-available/wsgi.conf',
  } ->
  file { '/etc/apache2/mods-enabled/socache_shmcb.load' :
    ensure => 'link',
    target => '/etc/apache2/mods-available/socache_shmcb.load',
  } ->
  file { '/etc/apache2/mods-enabled/ssl.load' :
    ensure => 'link',
    target => '/etc/apache2/mods-available/ssl.load',
  } ->
  file { '/etc/apache2/mods-enabled/ssl.conf' :
    ensure => 'link',
    target => '/etc/apache2/mods-available/ssl.conf',
  }

### the end ###
}
