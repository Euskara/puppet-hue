class hue (
  $version               = $hue::params::version,
  $install_dir           = $hue::params::install_dir,
  $config_file           = $hue::params::config_file,
  $install_method        = $hue::params::install_method,
  $install_prefix        = $hue::params::install_prefix,
  $mirror_url            = $hue::params::mirror_url,
  $config                = {},
  $config_defaults       = $hue::params::config_defaults,
  $install_dependencies  = $hue::params::install_dependencies,
  $packages_dependencies = $hue::params::packages_dependencies,
  $install_python        = $hue::params::install_python,
  $install_java          = $hue::params::install_java,
  $install_maven         = $hue::params::install_maven,
  $package_dir           = $hue::params::package_dir,
  $service_install       = $hue::params::service_install,
  $service_ensure        = $hue::params::service_ensure,
  $service_restart       = $hue::params::service_restart,
  $package_name          = $hue::params::package_name,
  $package_ensure        = $hue::params::package_ensure,
  $group_id              = $hue::params::group_id,
  $user_id               = $hue::params::user_id,

  $config_dir      = $hue::params::config_dir,
  $custom_config   = {},
  $pid_location    = $hue::params::pid_location,
  $log_dir         = $hue::params::log_dir,

) inherits hue::params {

  validate_re($::osfamily, 'RedHat|Debian\b', "${::operatingsystem} not supported")

  validate_bool($install_dependencies)
  validate_bool($install_python)
  validate_bool($install_java)
  validate_bool($install_maven)

  validate_hash($custom_config)

  $basefilename = "hue-${version}.tgz"
  $package_url  = "${mirror_url}/${version}/${basefilename}"

  $install_directory = $install_dir ? {
    $hue::params::install_dir => "/opt/hue-${version}",
    default                   => $install_dir,
  }

  group { 'hue':
    ensure => present,
    system => true,
    gid    => $group_id,
  }

  user { 'hue':
    ensure     => present,
    system     => true,
    comment    => 'Apache Hue',
    home       => '/usr/lib/hue',
    managehome => true,
    groups     => 'hue',
    uid        => $user_id,
    shell      => '/sbin/nologin',
    require    => Group['hue'],
  }

  file { $package_dir:
    ensure  => directory,
    owner   => 'hue',
    group   => 'hue',
    require => [
      Group['hue'],
      User['hue'],
    ],
  }

  file { $install_directory:
    ensure  => directory,
    owner   => 'hue',
    group   => 'hue',
    require => [
      Group['hue'],
      User['hue'],
    ],
  }

  file { '/opt/hue':
    ensure  => link,
    target  => $install_directory,
    require => File[$install_directory],
  }

  file { '/var/log/hue':
    ensure  => directory,
    owner   => 'hue',
    group   => 'hue',
    require => [
      Group['hue'],
      User['hue'],
    ],
  }

  if $install_python {
    class { '::python':
      version => 'system',
      pip     => 'present',
      dev     => 'present',
      before  => Exec[ 'install hue' ],
    }
  }
  if $install_java {
    java::oracle { 'jdk8':
      ensure  => 'present',
      version => '8',
      java_se => 'jdk',
      before  => Exec[ 'install hue' ],
    }
  }
  if $install_maven {
    class { '::maven': } -> Exec[ 'install hue' ]
  }
  if $install_dependencies {
    package { $packages_dependencies:
      ensure => present,
      before => Exec[ 'install hue' ],
    }
  }

  class { '::hue::install': } ->
  class { '::hue::config': } ->
  class { '::hue::service': }
}
