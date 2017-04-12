# == Class: cix_ldap::server::service
#
# Manage the ldap server service
#
class cix_ldap::server::service inherits cix_ldap::server {
  if $cix_ldap::server::service_manage == true {
    service { 'ldap-server':
      ensure     => $cix_ldap::server::service_ensure,
      enable     => $cix_ldap::server::service_enable,
      name       => $cix_ldap::server::service_name,
      hasstatus  => true,
      hasrestart => true,
    }
  }
}
