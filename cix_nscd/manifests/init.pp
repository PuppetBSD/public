class cix_nscd (
) inherits cix_nscd::params {

	service { $service_name:
		ensure  => running,
		name    => $service_name,
		enable  => true,
		status  => 'service nscd status',
	}

	file { "/etc/nscd.conf":
		ensure  => present,
		content => template("$module_name/freebsd-nscd.conf.erb"),
		mode => '0644',
	}

}
