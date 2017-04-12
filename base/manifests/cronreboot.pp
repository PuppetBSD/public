class base::cronreboot {

	package { 'mailutils': ensure=>installed }

	cron { "reboot notify":
		command => "/bin/echo \"Incident date: `/usr/bin/env LANG=C /bin/date`\"| mail -s \"`/bin/hostname` rebooted\" root",
		user    => "root",
		special => "reboot",
		ensure => $ensure,
	}

}
