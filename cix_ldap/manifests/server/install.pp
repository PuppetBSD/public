# == Class: cix_ldap::server::install
#
# Manage the installation of the ldap server package
#
class cix_ldap::server::install inherits cix_ldap::server {
  package { 'ldap-server':
    ensure => $cix_ldap::server::package_ensure,
    name   => $cix_ldap::server::package_name,
  }
}
