# /usr/share/puppet/testing/public/modules/base/manifests/init.pp

class base {

	# это то, что подойдет всем, включая докеры
#	require base::ldap
	require base::datetime
	require base::ssh_public_keys_admins
#	require base::ssh_public_keys_root
#	require base::disable_ipv6
	require base::locale
	require base::bindir
	require base::cronaptupdate
	require base::users
	require base::mail_aliases

	include base::aptdevim
	include base::cronreboot
	include vpnroute

#	class { 'sysctl::base': hiera_merge_values => true,}

	case $::virtual {
		'lxc': {
		}
		default: {
			include sysctl::base
		}
	}

	case $operatingsystem {
		'ubuntu': {
			require base::puppet
		}
	}

	require base::packages
#	require base::aptmbt
#	require base::facts
	require base::ipmitools

#	case $::virtual {
#		'lxc': {
#		}
#		default: {
#			include sysctl::base
#			}
#	}

#	include nscd
#	include users

#	include mcossl
#	include mcoserver

#	class { "factd_mbt": }
#	factd_mbt::addfacter { ["descr","location","mgmtip","country","users"]: }

}
