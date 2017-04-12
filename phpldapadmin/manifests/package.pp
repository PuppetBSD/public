# == Class: phpldapadmin::package
#
# === Authors
#
# Sebastian Otaegui
#
# === Copyright
#
# Copyright 2014 Sebastian Otaegui
#
class phpldapadmin::package {

  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  package { $phpldapadmin::params::package_name:
    ensure => latest,
  }
}
