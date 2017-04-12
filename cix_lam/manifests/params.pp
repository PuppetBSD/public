class cix_lam::params {

  $ldap_host = '127.0.0.1'

  case $::osfamily {
    'Debian': {
      $config_path = '/etc/lam'
      $config_group = 'www-data'
      $config_user = 'www-data'
      $package_name = 'ldap-account-manager'
    }

    'RedHat': {
      $config_path = '/etc/lam'
      $config_group = 'apache'
      $config_user = 'apache'
      $package_name = 'ldap-account-manager'
    }

    'FreeBSD': {
      $config_path = '/usr/local/www/lam'
      $config_group = 'www'
      $config_user = 'www'
      $package_name = 'ldap-account-manager'
    }

    default: {
      fail("Unsupported OS family ${::osfamily}")
    }
  }
}
