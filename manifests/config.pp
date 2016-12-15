class hue::config (
  $config_dir      = $hue::config_dir,
  $config_file     = $hue::config_file,
  $config_defaults = $hue::params::config_defaults,
  $custom_config   = $hue::custom_config,
  $service_name    = $hue::params::service_name,
)
{

  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  $hue_config = deep_merge($config_defaults, $custom_config)

  file { $config_dir:
    ensure => directory,
    mode   => '0664',
    owner  => 'hue',
    group  => 'hue',
  }
  file { $config_file:
    ensure  => file,
    content => template('hue/hue.ini.erb'),
    mode    => '0644',
    owner   => 'hue',
    group   => 'hue',
    notify  => Service[ $service_name ],
    require => File[ $config_dir ],
  }

}