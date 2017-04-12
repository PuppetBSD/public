# == Class: phpldapadmin::config
#
# Full description of class phpldapadmin:config here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Authors
#
# Sebastian Otaegui
#
# === Copyright
#
# Copyright 2014 Sebastian Otaegui
#
class phpldapadmin::config(
  $config_path = $phpldapadmin::config_path,
  $ldap_suffix = undef,
  $ldap_host = $phpldapadmin::ldap_host,
  $ldap_bind_id = undef,
  $ldap_bind_pass = undef,
  $extraconf = $phpldapadmin::extraconf,
) {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  file { "${phpldapadmin::config_path}/config.php":
    ensure  => file,
    content => template("${module_name}/config.php.erb"),
    path    => "${phpldapadmin::config_path}/config.php",
    owner   => 'root',
    group   => $phpldapadmin::params::config_group,
    mode    => '0640',
  }
}
