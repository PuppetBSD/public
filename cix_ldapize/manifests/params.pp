# Class: cix_ldapize::params
#
# Defines all the variables used in the module.
#
class cix_ldapize::params {
  case $::osfamily {
    'Debian': {
      $package = 'tzdata'
    }
    'FreeBSD': {
      $packages = [ "security/pam_mkhomedir", "net/nss_ldap", "security/pam_ldap" ]
    }
    default: {
      case $::operatingsystem {
        default: {
          fail("Unsupported platform: ${::osfamily}/${::operatingsystem}")
        }
      }
    }
  }
}
