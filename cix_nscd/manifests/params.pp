class cix_nscd::params {

  case $::operatingsystem {
    'OpenBSD': {
    }
    'FreeBSD': {
      $package_name = 'nscd'
      $service_name = 'nscd'
    }
    default: {
      fail('nsd not supported on this platform, please help add support!')
    }
  }
}
