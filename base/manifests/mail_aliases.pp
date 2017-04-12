class base::mail_aliases {

	file { "/etc/aliases":
		source => [
			"puppet://${server}/modules/base/etc/aliases" ],
		mode => '0644',
	}

	file { "/etc/aliases.db":
		source => [
			"puppet://${server}/modules/base/etc/aliases.db" ],
		mode => '0644',
	}
}
