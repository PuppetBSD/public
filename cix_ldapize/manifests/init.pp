class cix_ldapize ( $ensure=present,
	$ldap_host="ldap0.cix.com",
	$ldap_suffix="dc=cix,dc=com",
	$ldap_ou="ou=People",
#	$ou=undef,
	$ldap_bind_id=undef,
	$ldap_bind_password=undef
	) inherits cix_ldapize::params {

	package { $packages:
		ensure  => $ensure
	}

	# for nsswitch.conf
	if $ensure == "absent" {
		$ldapize=undef
	} else {
		$ldapize=true
	}

	file {'/usr/local/etc/openldap':
		ensure => directory,
	}

	file { "/usr/local/etc/ldap.conf":
		ensure  => present,
		content => template("$module_name/ldap.conf.erb"),
		mode => '0644',
	}

	file { "/etc/nsswitch.conf":
		ensure  => present,
		content => template("$module_name/freebsd-nsswitch.conf.erb"),
		mode => '0644',
	}

	file { "/etc/pam.d/sshd":
		ensure  => present,
		content => template("$module_name/freebsd-sshd.erb"),
		mode => '0644',
	}

	file { "/root/bin/ldap-keys":
		ensure  => present,
		content => template("$module_name/ldap-keys.erb"),
		mode => '0555',
	}

	file { "/usr/local/etc/nss_ldap.conf":
		ensure  => present,
		content => template("$module_name/nss_ldap.conf.erb"),
		mode => '0644',
	}

	file { "/usr/local/etc/openldap/ldap.conf":
		ensure  => present,
		content => template("$module_name/openldap/ldap.conf.erb"),
		mode => '0644',
		require => File["/usr/local/etc/openldap"],
	}

}
