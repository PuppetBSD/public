class base::bindir {

	file { "/root/bin/fw.stop":
		source => [
			"puppet://${server}/modules/base/fw.stop" ],
		mode => '0755',
		require=> File["/root/bin"]
	}

	file { "/root/bin/notify-by-sms.sh":
		source => [
			"puppet://${server}/modules/base/notify-by-sms.sh" ],
		mode => '0555',
		require=> File["/root/bin"]
	}

	file { "/root/bin/notify-by-slack.sh":
		source => [
			"puppet://${server}/modules/base/notify-by-slack.sh" ],
		mode => '0555',
		require=> File["/root/bin"]
	}


#	file { "/etc/modprobe.d/blacklist-conntrack.conf":
#		ensure => absent;
#	}
}
