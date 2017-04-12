# alternative openldap name sets via $openldapname

class cix_openldap(
	$ensure=present,
	$ldap_suffix='dc=example,dc=com',
	$ldap_bind_id='cn=admin,dc=example,dc=com',
	$ldap_bind_password='password',
	$ldap_bind_ro_id=undef,
	$ldap_bind_ro_password=undef,
	$ldap_server_id=undef,
	$ldap_server_provider=undef,
	 ) inherits cix_openldap::params {

	anchor { 'cix_openldap::begin':
		before => Class['::cix_openldap::package'],
	}

	class { '::cix_openldap::package':
		require => Anchor['cix_openldap::begin'],
	}

	class { '::cix_openldap::config':
		ldap_suffix => $ldap_suffix,
		ldap_bind_id => $ldap_bind_id,
		ldap_bind_password => $ldap_bind_password,
		require => Class['::cix_openldap::package'],
	}

	anchor {'cix_openldap::end':
		require => Class['::cix_openldap::config'],
	}
}
