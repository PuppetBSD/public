# Class rtorrent::params
# Include default parameters for rtorrent class
class rtorrent::params {
  $package_name = 'net-p2p/rtorrent'
  $package_ensure = 'installed'
  $service_name = 'rtorrent'
  $user = 'www'
  $group = 'www'

  case $::osfamily {
    'RedHat', 'Linux': {
      $config_dir = '/etc/rtorrent'
    }
    'FreeBSD': {
      $config_dir = '/usr/local/etc'
    }
  }
}
