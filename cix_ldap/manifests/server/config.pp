# == Class: cix_ldap::server::config
#
# Manage the configuration of the ldap server service
#
class cix_ldap::server::config inherits cix_ldap::server {
  # If $config is true, we will be configuring the "config" LDAP database
  # for storing OpenLDAP configurations in LDAP itself.
  if $config {
    # If $configdn is set, use that in the template.  Else use $rootdn
    if $configdn {
      $_configdn = $configdn
    } else {
      $_configdn = $::cix_ldap::server::rootdn
    }
    # If $configpw is set, use that in the template.  Else use $rootpw
    if $configpw {
      $_configpw = $configpw
    } else {
      $_configpw = $::cix_ldap::server::rootpw
    }
  }

  # If $monitor is true, we will be configuring the "monitor" LDAP database
  # which allows us to query the LDAP server for statistics about itself
  if $monitor {
    # If $monitordn is set, use that in the template.  Else use $rootdn
    if $monitordn {
      $_monitordn = $monitordn
    } else {
      $_monitordn = $::cix_ldap::server::rootdn
    }
    # If $monitorpw is set, use that in the template.  Else use $rootpw
    if $monitorpw {
      $_monitorpw = $monitorpw
    } else {
      $_monitorpw = $::cix_ldap::server::rootpw
    }
  }

  file { $cix_ldap::server::config_file:
    owner   => $cix_ldap::server::ldapowner,
    group   => $cix_ldap::server::ldapgroup,
    # may contain passwords
    mode    => $cix_ldap::server::config_file_mode,
    content => template($cix_ldap::server::config_template),
  }

  if $cix_ldap::server::default_file {
    file { $cix_ldap::server::default_file:
      owner   => 0,
      group   => 0,
      mode    => $cix_ldap::server::default_file_mode,
      content => template($cix_ldap::server::default_template),
    }
  }

  file { $cix_ldap::server::schema_directory:
    ensure => directory,
    owner  => 0,
    group  => 0,
    mode   => $cix_ldap::server::schema_directory_mode,
  }
  ->
  cix_ldap::schema_file { $cix_ldap::server::extra_schemas:
    directory        => $cix_ldap::server::schema_directory,
    source_directory => $cix_ldap::server::schema_source_directory,
  }

  file { $cix_ldap::server::directory:
    ensure => directory,
    owner  => $cix_ldap::server::ldapowner,
    group  => $cix_ldap::server::ldapgroup,
    mode   => $cix_ldap::server::directory_mode,
  }

  file { $cix_ldap::server::run_directory:
    ensure => directory,
    owner  => $cix_ldap::server::ldapowner,
    group  => $cix_ldap::server::ldapgroup,
    mode   => $cix_ldap::server::run_directory_mode,
  }

  if $cix_ldap::server::backend == 'bdb' or $cix_ldap::server::backend == 'hdb' {
    file { $cix_ldap::server::db_config_file:
      owner   => $cix_ldap::server::ldapowner,
      group   => $cix_ldap::server::ldapgroup,
      mode    => $cix_ldap::server::db_config_file_mode,
      content => template($cix_ldap::server::db_config_template),
      require => File[$cix_ldap::server::directory],
    }
  }

  if $cix_ldap::server::dynconfig_directory and $cix_ldap::server::purge_dynconfig_directory == true {
    file { $cix_ldap::server::dynconfig_directory:
      ensure  => absent,
      path    => $cix_ldap::server::dynconfig_directory,
      recurse => true,
      purge   => true,
      force   => true,
    }
  }
}
