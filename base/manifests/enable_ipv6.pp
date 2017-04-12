class base::enable_ipv6 {
	sysctl { 'net.ipv6.conf.default.disable_ipv6': value => '0' }
	sysctl { 'net.ipv6.conf.lo.disable_ipv6': value => '0' }
	sysctl { 'net.ipv6.conf.all.disable_ipv6': value => '0' }
}

