class base::puppet {

	apt::source { 'puppetlabs':
		location => 'http://apt.puppetlabs.com',
		repos    => 'main',
		key      => {
			'id'     => '47B320EB4C7C375AA9DAE1A01054B7A24BD6EC30',
			'server' => 'pgp.mit.edu',
		},
	}

	apt::pin { 'puppetlabs': priority => 100 }

	$packages = "puppet-agent"

	package { $packages:
		ensure => "latest",
	}

	$no_packages = "puppet"

	package { $no_packages:
		ensure => "absent"
	}

	file { '/usr/local/bin/puppet':
		ensure=> 'link',
		target=> '/opt/puppetlabs/puppet/bin/puppet',
	}

	file { '/usr/local/bin/hiera':
		ensure=> 'link',
		target=> '/opt/puppetlabs/puppet/bin/hiera',
	}

	file { '/usr/local/bin/facter':
		ensure=> 'link',
		target=> '/opt/puppetlabs/puppet/bin/facter',
	}

	file { '/usr/local/bin/mco':
		ensure=> 'link',
		target=> '/opt/puppetlabs/puppet/bin/mco',
	}

	$runs_per_hour = 3

        # lets make start puppet haotic and randomize within hour
        $minutes_str = inline_template("<%-
                n = @runs_per_hour.to_i
                i = 60/n
                splay = scope.function_fqdn_rand([i]).to_i
                minutes = []
                n.times do |k|
                        minute = i*k+splay
                        if minute >= 60
                                minute = minute - 60
                        end
                        minutes << minute
                end
        -%><%=minutes.join(',')%>")

        $minutes_arr = split($minutes_str, ',')

        $croncmd = "timeout -s 15 1000 nice -n 19 /opt/puppetlabs/bin/puppet agent --onetime --no-daemonize --logdest syslog > /dev/null 2>&1"

        cron { "puppetd":
                require => Package["puppet"],
                command => $croncmd,
                user    => "root",
                hour    => "*",
                minute  => $minutes_arr,
                ensure  => present,
                environment => [ 'PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin', 'MAILTO=/dev/null', ]
        }

}
