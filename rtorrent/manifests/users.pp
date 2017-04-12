class rtorrent::users {

	group { "$::rtorrent::group":
		ensure     => present,
		forcelocal => true,
	}

	user { "$::rtorrent::user":
		ensure => present,
		forcelocal => true,
		groups     => [ "$::rtorrent::group" ],
		shell      => '/bin/sh',
		home       => "/usr/home/web",
	}
}
