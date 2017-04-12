class teamcity::config inherits teamcity::params {

  $auth      = $::teamcity::params::authentication
  $ldap      = $::teamcity::params::ldap_configuration
  $ldap_file = "${::teamcity::params::teamcity_data_path}/config/ldap-config.properties"

  if $auth == ldap and $ldap != 'external' {

    file { $ldap_file:
      ensure  => 'present',
      content => $ldap,
    }

  } else {

    # if local authentication prevent manual ldap configuration. if you
    # want to set ldap manually, set to "external" above :)
    file { $ldap_file:
      ensure => 'absent',
    }

  }

}
