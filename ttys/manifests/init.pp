# Class: ttys
# ===========================
#
# Full description of class ttys here.
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
# class { "ttys":
#   ttyv => [
#     { name => 'console',    getty => 'none',                                type => 'unknown',      status => 'off',                comments => 'secure' },
#     { name => 'ttyv0',      getty => '"/usr/libexec/getty Pc"',             type => 'xterm',        status => 'on',                 comments => 'secure' },
#     { name => 'ttyv1',      getty => '"/usr/libexec/getty Pc"',             type => 'xterm',        status => 'on',                 comments => 'secure' },
#     { name => 'ttyv2',      getty => '"/usr/libexec/getty Pc"',             type => 'xterm',        status => 'on',                 comments => 'secure' },
#     { name => 'ttyu0',      getty => '"/usr/libexec/getty 3wire"',          type => 'vt100',        status => 'onifconsole',        comments => 'secure' },
#     { name => 'ttyu1',      getty => '"/usr/libexec/getty 3wire"',          type => 'vt100',        status => 'onifconsole',        comments => 'secure' },
#     { name => 'dcons',      getty => '"/usr/libexec/getty std.9600"',       type => 'vt100',        status => 'off',                comments => 'secure' },
#   ],
# }
#
# Authors
# -------
#
# Oleg Ginzburg <olevole@olevole.ru>
#
# Copyright
# ---------
#
# Copyright 2016 Your name here, unless otherwise noted.
#
class ttys (
	$ttyv="",
	$ttys_file = $ttys::params::ttys_file,
) inherits ttys::params {

	if $ttyv == "" {
		fail("$module_name: empty ttyv variable")
	}

	file { $ttys_file:
		mode => '0644',
		ensure  => present,
		content => template("${module_name}/ttys.erb"),
		owner => 0,
		group => 0,
	}

	exec { 'update_timezone':
		command     => "kill -1 1",
		path        => '/usr/bin:/usr/sbin:/bin:/sbin',
		subscribe   => File[$ttys_file],
		refreshonly => true,
	}
}
