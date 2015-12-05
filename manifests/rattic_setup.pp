class rattic::rattic_setup {
  
  $version = "1.2.2"

####################################################################################
### rattic
####################################################################################

  file { '/opt/apps' :
    ensure  => 'directory',
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
  }

  exec { 'wget' :
    command => 'wget https://github.com/tildaslash/RatticWeb/archive/v{version}.tar.gz',
    cwd     => '/opt/apps',
    creates => "/opt/apps/v${version}.tar.gz",
    path    => "/usr/bin/",
    require => File['/opt/apps'],
  }

  exec { 'extract' :
    command => "tar -zxvf v${version}.tar.gz",
    cwd     => '/opt/apps',
    creates => "/opt/apps/RatticWeb-${version}",
    path    => "/usr/local/bin/:/bin/",
    require => Exec['wget'],
  }

  exec { "rename":
    command => "mv /opt/apps/RatticWeb-${version} /opt/apps/RatticWeb",
    creates => "/opt/apps/RatticWeb",
    path    => "/usr/local/bin/:/bin/",
    require => Exec['extract'],
  }

  file { '/opt/apps/RatticWeb/static' :
    ensure  => 'directory',
    owner   => 'root',
    group   => 'root',
    mode    => '0775',
    require => Exec['rename'],
  }

  file { '/opt/apps/RatticWeb/conf/local.cfg' :
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '644',
    source  => 'puppet:///modules/rattic/local.cfg',
    require  => Exec['rename'],
  }

  file { '/opt/apps/rattic.script' :
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0700',
    source  => 'puppet:///modules/rattic/rattic_script',
    require => File['/opt/apps'],
  }

  exec { "initial_setup":
    command => "/opt/apps/rattic.script",
    require => File['/opt/apps/RatticWeb/conf/local.cfg', '/opt/apps/rattic.script'],
  }

### the end ###
}
