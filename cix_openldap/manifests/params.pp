class cix_openldap::params {
	case $::osfamily {
		freebsd: {
			$openldapconfigdir = "/usr/local/etc/openldap"
			$openldapconfig = "/usr/local/etc/openldap/ldap.conf"
			$slapdconfig = "/usr/local/etc/openldap/slapd.conf"
			$servicename = "slapd"
			$package_name = [ "openldap-server" ]
			}
		debian, ubuntu: {
			$openldapconfigdir = "/etc/openldap"
			$openldapconfig = "/etc/openldap/ldap.conf"
			$servicename = "slapd"
			$package_name = [ "openldap-tools", "openldap-server" ]
			}
		default: {
			fail("Unsupported OS family ${::osfamily}")
			}
	}
}
