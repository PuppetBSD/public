class cix_lam(
  $config_path  = $cix_lam::params::config_path,
  $ldap_host = $cix_lam::params::ldap_host,
  $ldap_suffix = undef,
  $ldap_bind_id = undef,
  $ldap_bind_pass = undef,
  $sha_password = undef,
  $extraconf = undef,
  $lam_shells = "/bin/bash+::+/bin/csh+::+/bin/dash+::+/bin/false+::+/bin/ksh+::+/bin/sh",
) inherits cix_lam::params {

  debug("Using ldap_host: ${ldap_host}")
  validate_string($ldap_host)
  if ( !is_string($ldap_host) and !is_ip_address($ldap_host) ) {
    fail('Invalid param ldap_host, must be ip or hostname')
  }

  debug("Using ldap_suffix ${ldap_suffix}")
  validate_string($ldap_suffix)
  if ( !is_string($ldap_suffix) ) {
    fail('Invalid param ldap_suffix, must be ip or hostname')
  }

  debug("Using ldap_bind_id ${ldap_bind_id}")
  validate_string($ldap_bind_id)

  if $ldap_bind_pass != undef {
    debug("Using ldap_bind_pass ${ldap_bind_pass}")
    validate_string($ldap_bind_pass)
  }

  debug("Using config_path ${config_path}")
  validate_absolute_path($config_path)

  anchor { 'cix_lam::begin':
    before => Class['::cix_lam::package'],
  }
  class { '::cix_lam::package':
    require => Anchor['cix_lam::begin'],
  }
  class {'::cix_lam::config':
    config_path    => $config_path,
    ldap_host      => $ldap_host,
    ldap_suffix    => $ldap_suffix,
    ldap_bind_id   => $ldap_bind_id,
    ldap_bind_pass => $ldap_bind_pass,
    sha_password   => $sha_password,
    extraconf      => $extraconf,
    require        => Class['::cix_lam::package'],
  }
  anchor {'cix_lam::end':
    require => Class['::cix_lam::config'],
  }

}
