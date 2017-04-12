class cix_lam::config(
  $config_path = $cix_lam::config_path,
  $ldap_suffix = undef,
  $ldap_host = $cix_lam::ldap_host,
  $ldap_bind_id = undef,
  $ldap_bind_pass = undef,
  $sha_password = undef,
  $lam_shells = "/bin/bash+::+/bin/csh+::+/bin/dash+::+/bin/false+::+/bin/ksh+::+/bin/sh",
  $extraconf = $cix_lam::extraconf,
) {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  file { "${cix_lam::config_path}/config/config.cfg":
    ensure  => file,
    content => template("${module_name}/config.cfg.erb"),
    path    => "${cix_lam::config_path}/config/config.cfg",
    owner   => $cix_lam::params::config_user,
    group   => $cix_lam::params::config_group,
    mode    => '0640',
  }

  file { "${cix_lam::config_path}/config/lam.conf":
    ensure  => file,
    content => template("${module_name}/lam.conf.erb"),
    path    => "${cix_lam::config_path}/config/lam.conf",
    owner   => $cix_lam::params::config_user,
    group   => $cix_lam::params::config_group,
    mode    => '0640',
  }

#  file { "${cix_lam::config_path}/config/nginx-vhost.conf":
#    ensure  => file,
#    content => template("${module_name}/nginx-vhost.conf.erb"),
#    path    => "${cix_lam::config_path}/config/nginx-vhost.conf",
#    owner   => $cix_lam::params::config_user,
#    group   => $cix_lam::params::config_group,
#    mode    => '0640',
#  }

	$no_cix_lam_profiles = [ 'addressbook.conf','nginx-vhost.conf','samba3.conf','unix.conf','windows_samba4.conf' ]

	# function call with cix_lambda:
	$no_cix_lam_profiles.each |String $profiles| {
		file {"${cix_lam::config_path}/config/${profiles}":
			ensure => absent,
		}
	}

}
