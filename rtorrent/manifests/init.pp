# Class: rtorrent
# ===========================
#
# Full description of class rtorrent here.
#
# Parameters
# ----------
#
# Document parameters here.
#
# * `sample parameter`
# Explanation of what this parameter affects and what it defaults to.
# e.g. "Specify one or more upstream ntp servers as an array."
#
# Variables
# ----------
#
# Here you should define a list of variables that this module would require.
#
# * `sample variable`
#  Explanation of how this variable affects the function of this class and if
#  it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#  External Node Classifier as a comma separated list of hostnames." (Note,
#  global variables should be avoided in favor of class parameters as
#  of Puppet 2.6.)
#
# Examples
# --------
#
# @example
#    class { 'rtorrent':
#      ip4_addr => "10.0.0.5/24",
#    }
#
# Authors
# -------
#
# Author Name <olevole@olevole.ru>
#
# Copyright
# ---------
#
# Copyright 2017 Oleg Ginzburg
#
class rtorrent (
  $package_name		= $::rtorrent::params::package_name,
  $package_ensure	= $::rtorrent::params::package_ensure,
  $service_name		= $::rtorrent::params::service_name,
  $user			= $::rtorrent::params::user,
  $group		= $::rtorrent::params::group,
) inherits rtorrent::params {

	contain '::rtorrent::setenv'
	contain '::rtorrent::install'
	contain '::rtorrent::users'
	contain '::rtorrent::dir'

	Class['::rtorrent::setenv'] ->
	Class['::rtorrent::install'] ->
	Class['::rtorrent::users'] ->
	Class['::rtorrent::dir']

	service { 'rtorrent':
		ensure => running,
		enable => true,
	}

}
