class cix_openldap::package {
	if $caller_module_name != $module_name {
		fail("Use of private class ${name} by ${caller_module_name}")
	}

	package { $cix_openldap::params::package_name:
		ensure => latest,
	}
}
