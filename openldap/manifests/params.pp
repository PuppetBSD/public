# See README.md for details.
class openldap::params {
  case $::osfamily {
    'Debian': {
      $client_package           = 'libldap-2.4-2'
      $client_conffile          = '/etc/ldap/ldap.conf'
      $server_confdir           = '/etc/ldap/slapd.d'
      $server_conffile          = '/etc/ldap/slapd.conf'
      $server_group             = 'openldap'
      $server_owner             = 'openldap'
      $server_package           = 'slapd'
      $server_service           = 'slapd'
      if $::operatingsystem == 'Debian' and $::operatingsystemmajrelease == '5' {
        $server_service_hasstatus = false
      } else {
        $server_service_hasstatus = true
      }
      $utils_package            = 'ldap-utils'
    }
    'FreeBSD': {
      $client_package           = 'net/openldap24-sasl-client'
      $client_conffile          = '/usr/local/etc/openldap/ldap.conf'
      $server_confdir           = '/usr/local/etc/openldap/slapd.d'
      $server_conffile          = '/usr/local/etc/openldap/slapd.conf'
      $server_group             = 'ldap'
      $server_owner             = 'ldap'
      $server_package           = 'misc/mc'
      #net/openldap24-sasl-server'
      $server_service           = 'slapd'
      $server_service_hasstatus = true
      $utils_package            = 'net/openldap24-sasl-client'
    }
    'RedHat': {
      $client_package           = 'openldap'
      $client_conffile          = '/etc/openldap/ldap.conf'
      $server_confdir           = '/etc/openldap/slapd.d'
      $server_conffile          = '/etc/openldap/slapd.conf'
      $server_group             = 'ldap'
      $server_owner             = 'ldap'
      $server_package           = 'openldap-servers'
      $server_service           = $::operatingsystemmajrelease ? {
        '5' => 'ldap',
        '6' => 'slapd',
        '7' => 'slapd',
      }
      $server_service_hasstatus = true
      $utils_package            = 'openldap-clients'
    }
    default: {
      fail "Operating System family ${::osfamily} not supported"
    }
  }
}
