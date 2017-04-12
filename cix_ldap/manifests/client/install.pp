# == Class: cix_ldap::client::install
#
# Manage the installation of the ldap client package
#
class cix_ldap::client::install inherits cix_ldap::client {
  package { 'ldap-client':
    ensure => $cix_ldap::client::package_ensure,
    name   => $cix_ldap::client::package_name,
  }


  case $::osfamily {
    'FreeBSD': {
      if $cix_ldap::client::manage_package_dependencies {
        package { 'net-ldap':
          ensure   => $cix_ldap::client::net_ldap_package_ensure,
          name     => $cix_ldap::client::net_ldap_package_name,
          provider => $cix_ldap::client::net_ldap_package_provider,
        }
      }
    }
    default: {
      if versioncmp($::puppetversion, '4.0.0') > 0 {

        # Puppet 4 has its own self-contained ruby environment so install the
        # requisite packages there
        exec { '/opt/puppetlabs/puppet/bin/gem install net-ldap':
          unless => '/opt/puppetlabs/puppet/bin/gem list | grep net-ldap',
        }

      } else {
        package { 'net-ldap':
          ensure   => $cix_ldap::client::net_ldap_package_ensure,
          name     => $cix_ldap::client::net_ldap_package_name,
          provider => $cix_ldap::client::net_ldap_package_provider,
        }
      }
    }
  }
}
