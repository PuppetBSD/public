class cix_openldap::config(
	$openldapconfigdir = $cix_openldap::openldapconfigdir,
	$openldapconfig = $cix_openldap::openldapconfig,
	$servicename = $cix_openldap::servicename,
	$slapdconfig = $cix_openldap::slapdconfig,
	$ldap_server_id = $cix_openldap::ldap_server_id,
	$ldap_server_provider = $cix_openldap::ldap_server_provider,
	$ldap_bind_ro_id = $cix_openldap::ldap_bind_ro_id,
	$ldap_bind_ro_password = $cix_openldap::ldap_bind_ro_password,
	$ensure=present,
	$ldap_suffix='dc=example,dc=com',
	$ldap_bind_id='cn=admin,dc=example,dc=com',
	$ldap_bind_password='password',
) {
	if $caller_module_name != $module_name {
		fail("Use of private class ${name} by ${caller_module_name}")
	}

	file { "$openldapconfig":
		notify  => $notify_restart ? {
			true    => Exec["openldap-server_restart"],
			default => undef,
		},
		mode => '0600',
		ensure  => present,
		content => template("${module_name}/ldap.conf.erb"),
	}

	file { "$slapdconfig":
		notify  => $notify_restart ? {
			true    => Exec["openldap-server_restart"],
			default => undef,
		},
		owner => 'ldap',
		group => 'ldap',
		mode => '0600',
		ensure  => present,
		content => template("${module_name}/slapd.conf.erb"),
	}

	file { "/root/example_user.ldif":
		mode => '0400',
		ensure  => present,
		content => template("${module_name}/example_user.ldif.erb"),
	}

	file { "/root/example.ldif":
		mode => '0400',
		ensure  => present,
		content => template("${module_name}/example.ldif.erb"),
		notify => Exec["/root/example.ldif"],
	}

	file { "/root/example_readonly_user.ldif":
		mode => '0400',
		ensure  => present,
		content => template("${module_name}/example_readonly_user.ldif.erb"),
	}

	file { "${openldapconfigdir}/schema/openssh-lpk-openldap.schema":
		source => [ "puppet://${server}/modules/${module_name}/openssh-lpk-openldap.schema" ],
		mode => '0644',
	}

	exec {"/root/example.ldif":
		command     => "service $servicename onerestart && sleep 2 && ldapadd -Z -D \"$ldap_bind_id\" -w $ldap_bind_password -f /root/example.ldif",
		refreshonly => true,
		require => [ Service["$servicename"], File["/root/example_user.ldif"] ]
	}

	exec {"openldap-server_restart":
		command     => "service $servicename restart",
		refreshonly => true,
	}

	service {"$servicename":
		enable     => true,
		hasrestart => true,
		hasstatus  => true,
	}
}
