class base::ldap {

	file {'/etc/ldap':
		ensure => directory,
		mode    => '0755',
	}

	file { "/etc/ldap/ca_server.pem":
		source => [ "puppet://${server}/modules/${module_name}/ldap/ca_server.pem" ],
		mode => '0644',
		ensure => present,
		require => File['/etc/ldap'],
	}

#	class { 'openldap::client': }


	file { "/usr/local/sbin/ldap-keys.pl":
                source  =>  [
                        "puppet://${server}/modules/base/ldap/ldap-keys.pl.${hostname}",
                        "puppet://${server}/modules/base/ldap/ldap-keys.pl",
                        ],
                owner  => "root",
                group  => "root",
                mode   => "0700",
	}

	file { "/usr/local/sbin/ldap-emails":
                source  =>  [
                        "puppet://${server}/modules/base/ldap/ldap-emails",
                        ],
                owner  => "root",
                group  => "root",
                mode   => "0700",
	}


#	$packages = [ "ldap-utils" ]

#	package { $packages:
#                ensure  => $ensure
#        }


}

