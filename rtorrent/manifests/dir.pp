class rtorrent::dir {

	file { "/usr/local/etc/rc.d/rtorrent":
		mode => '0555',
		ensure  => present,
		content => template("${module_name}/rtorrent.erb"),
	}

	exec { "clone_cp":
		command => "/usr/local/bin/git clone https://github.com/Novik/ruTorrent.git /usr/home/web/rutorrent",
		onlyif => "test ! -d /usr/home/web/rutorrent",
		require => File['/usr/home/web'],
	}

	exec { "chown_cp":
		command => "chown -R ${::rtorrent::user}:${::rtorrent::user} /usr/home/web/rutorrent",
		onlyif => "test -d /usr/home/web/rutorrent",
	}

	file { [ '/usr/home/web' ]:
		ensure => directory,
		owner => "${::rtorrent::user}",
		group => "${::rtorrent::user}",
	}

	file { [ '/usr/home/web/downloads' ]:
		ensure => directory,
		owner => "${::rtorrent::user}",
		group => "${::rtorrent::user}",
		require => File['/usr/home/web'],
	}

	file { [ '/usr/home/web/session' ]:
		ensure => directory,
		owner => "${::rtorrent::user}",
		group => "${::rtorrent::user}",
		require => File['/usr/home/web'],
	}

	file { "/usr/home/web/rutorrent/conf/config.php":
		mode => '0664',
		owner => "${::rtorrent::user}",
		group => "${::rtorrent::user}",
		ensure  => present,
		content => template("${module_name}/config.php.erb"),
	}

	file { "/usr/home/web/.rtorrent.rc":
		mode => '0664',
		owner => "${::rtorrent::user}",
		group => "${::rtorrent::user}",
		ensure  => present,
		content => template("${module_name}/.rtorrent.rc.erb"),
		require => File['/usr/home/web'],
	}

}
