class base::packages {

	$packages = hiera('devim_packages::packages')
	$ensure = hiera('devim_packages::ensure')

	package { $packages:
		ensure => $ensure,
	}

	$nopackages = [ 'accountsservice', 'cloud-init' ]

	package { $nopackages:
		ensure => absent,
	}

	file { "/etc/network/interfaces.d/50-cloud-init.cfg":
		ensure => absent;
	}

	file { "/etc/apt/apt.conf.d/01proxy":
		ensure => absent;
	}
}
