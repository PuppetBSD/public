class base::disable_ipv6 {
#         ::sysctl::conf  { "net.ipv6.conf.default.disable_ipv6": value => "1" }
#         ::sysctl::conf  { "net.ipv6.conf.all.disable_ipv6": value => "1" }
#         ::sysctl::conf  { "net.ipv6.conf.lo.disable_ipv6": value => "1" }

	sysctl { 'net.ipv6.conf.default.disable_ipv6': value => '1' }
	sysctl { 'net.ipv6.conf.lo.disable_ipv6': value => '1' }
	sysctl { 'net.ipv6.conf.all.disable_ipv6': value => '1' }

}

