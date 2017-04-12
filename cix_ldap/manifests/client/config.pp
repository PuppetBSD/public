# == Class: cix_ldap::client::config
#
# Manage the configuration of the ldap client
#
class cix_ldap::client::config inherits cix_ldap::client {
  file { $cix_ldap::client::config_file:
    owner   => 0,
    group   => 0,
    mode    => '0644',
    content => template($cix_ldap::client::config_template),
  }
}
