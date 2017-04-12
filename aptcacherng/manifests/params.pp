# == Class: aptcacherng::params
#
# parameter class for aptcacherng
#
# === Authors
#
# Mark Hellewell <mark.hellewell@gmail.com>
#
# === Copyright
#
# Copyright 2013 Mark Hellewell.
#
class aptcacherng::params {
  case $::osfamily {
    # covers debian and ubuntu, which is all we support
    'debian' : {
      $package = 'apt-cacher-ng'
    }
    default: {
      fail ("aptcacherng: ${::osfamily} not supported.")
    }
  }
}
