# == Class: cix_ldap::client
#
#  This class manages the installation and configuration of the OpenLDAP client
#
# === Parameters
#
# [*uri*]
#   The URI to the LDAP server(s) queries should be performed against.
#
# [*base*]
#   The domain for which the LDAP server provides information for.
#
# [*ssl*]
#   Whether the client should attempt to connect over SSL (false, true).
#
# [*ssl_cacert*]
#   Name of the CA Cert (OpenSSL: a filename, MozNSS: cert name in the certdb).
#
# [*ssl_cacertdir*]
#   Directory of the CA cert file (OpenSSL: a dirname, MozNSS: dirname where the certdb is).
#
# [*ssl_cert*]
#   SSL Certificate (OpenSSL: A filename, MozNSS: a cert name in the certdb).
#
# [*ssl_key*]
#   (OpenSSL: key file matching ssl_cert, MozNSS: filename to the password file for certdb).
#
# [*ssl_reqcert*]
#   How CA validation is being handled (never, allow, try, demand).
#
# [*ssl_ciphersuite*]
#   specify tls ciphersuite.
#
# [*manage_package_dependencies*]
#   Whether to automatically install additional software packages such as
#   net-ldap (Default: true).
#
# [*net_ldap_package_name*]
#   The name of the net-ldap package to install (Default: OS-dependant
#   ruby-net-ldap or net-ldap).
#
# [*net_ldap_package_ensure*]
#   The ensure of the net-ldap package (Default: present).
#
# [*net_ldap_package_provider*]
#  The provider of the net-ldap package (Default: OS-dependant apt or gem).
#
# [*sizelimit*]
#   Maximum number of entries to return by default.
#
# [*timelimit*]
#   Maximum number of seconds to wait for answers by default.
#
# === Examples
#
#  class { 'cix_ldap::client':
#    uri  => 'ldap://ldapserver01 ldap://ldapserver02',
#    base => 'dc=example,dc=com',
#  }
#
class cix_ldap::client (
  $uri,
  $base,
  $ssl              = $cix_ldap::params::client_ssl,
  $ssl_cacertdir    = $cix_ldap::params::client_ssl_cacertdir,
  $ssl_cacert       = $cix_ldap::params::client_ssl_cacert,
  $ssl_cert         = $cix_ldap::params::client_ssl_cert,
  $ssl_key          = $cix_ldap::params::client_ssl_key,
  $ssl_reqcert      = $cix_ldap::params::client_ssl_reqcert,
  $ssl_ciphersuite  = $cix_ldap::params::client_ssl_ciphersuite,
  $package_name     = $cix_ldap::params::client_package_name,
  $package_ensure   = $cix_ldap::params::client_package_ensure,
  $config_directory = $cix_ldap::params::ldap_config_directory,
  $config_file      = $cix_ldap::params::client_config_file,
  $config_template  = $cix_ldap::params::client_config_template,
  $manage_package_dependencies = $cix_ldap::params::manage_package_dependencies,
  $net_ldap_package_name       = $cix_ldap::params::net_ldap_package_name,
  $net_ldap_package_ensure     = $cix_ldap::params::net_ldap_package_ensure,
  $net_ldap_package_provider   = $cix_ldap::params::net_ldap_package_provider,
  $sizelimit        = $cix_ldap::params::client_sizelimit,
  $timelimit        = $cix_ldap::params::client_timelimit,
) inherits cix_ldap::params {

  include stdlib

  validate_string($uri)
  validate_string($base)
  validate_bool($ssl)
  if $ssl == true {
    if $ssl_cacertdir {
      validate_absolute_path($ssl_cacertdir)
    }
    validate_absolute_path($ssl_cacert)
    if $ssl_cert {
      validate_absolute_path($ssl_cert)
    }
    if $ssl_key {
      validate_absolute_path($ssl_key)
    }
    if $ssl_ciphersuite {
      validate_string($ssl_ciphersuite)
    }
    if $ssl_reqcert {
      validate_re($ssl_reqcert, ['never', 'allow', 'try', 'demand'])
    }
  }

  validate_bool($manage_package_dependencies)
  validate_string($net_ldap_package_name)
  validate_string($net_ldap_package_ensure)
  validate_string($net_ldap_package_provider)

  anchor { 'cix_ldap::client::begin': } ->
  class { '::cix_ldap::client::install': } ->
  class { '::cix_ldap::client::config': } ->
  anchor { 'cix_ldap::client::end': }
}
