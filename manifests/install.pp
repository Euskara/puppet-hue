class hue::install (
  $basefilename          = $hue::basefilename,
  $package_url           = $hue::package_url,
  $package_dir           = $hue::package_dir,
  $install_method        = $hue::install_method,
  $install_directory     = $hue::install_directory,
  $install_prefix        = $hue::install_prefix,
  $package_name          = $hue::package_name,
  $package_ensure        = $hue::package_ensure,
  $packages_dependencies = $hue::packages_dependencies,
  $install_python        = $hue::install_python,
  $install_java          = $hue::install_java,
  $install_maven         = $hue::install_maven,
)
{
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  case $install_method{
    'bin': {

      include '::archive'

      archive { "${package_dir}/${basefilename}":
        ensure          => present,
        extract         => true,
        extract_command => 'tar xfz %s --strip-components=1',
        extract_path    => $install_directory,
        source          => $package_url,
        creates         => "${install_directory}/Makefile",
        cleanup         => true,
        user            => 'hue',
        group           => 'hue',
        require         => [
          File[$package_dir],
          File[$install_directory],
          Group['hue'],
          User['hue'],
        ],
      }
      exec { 'install hue':
        command     => '/usr/bin/make install',
        cwd         => '/opt/hue',
        creates     => "${install_prefix}/hue",
        environment => "PREFIX=${install_prefix}",
        require     => Archive["${package_dir}/${basefilename}"],
      }
      file { "${install_prefix}/hue":
        ensure  => directory,
        owner   => 'hue',
        group   => 'hue',
        recurse => true,
        require => Exec[ 'install hue' ],
      }
    }
    'package': {
      package { $package_name:
        ensure => $package_ensure,
      }
    }
    default: {
      fail('wrong option')
    }
  }
}