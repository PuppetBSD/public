class rtorrent::install {

	class { 'php': }

	$packages = [ "sysutils/tmux", "devel/git", "security/ca_root_nss", "archivers/unrar", "archivers/rar", "archivers/zip", "multimedia/mediainfo", "multimedia/ffmpeg", "ftp/curl" ]

	package { $::rtorrent::package_name:
		ensure => $::rtorrent::package_ensure,
	}

	package { $packages:
		ensure => "installed",
	}

}
