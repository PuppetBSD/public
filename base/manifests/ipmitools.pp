class base::ipmitools {

	case $::virtual {
                'physical': {
                        package { 'ipmitool': ensure=>installed }
#                        package { 'mcelog': ensure=>installed }
                        package { 'hdparm': ensure=>installed }
#                        package { 'smartmontools': ensure=>installed }

                        exec {'/root/bin/ipmipass':
                                require     => File["ipmipass"],
                                subscribe   => File["ipmipass"],
                                command     => "/bin/sh /root/bin/ipmipass",
                                refreshonly => true,
                        }

                        file { 'ipmipass':
                                path    => '/root/bin/ipmipass',
				mode    => '0555',
                                source => [
                                        "puppet://${server}/modules/base/ipmitools/ipmipass.$fqdn",
                                        "puppet://${server}/modules/base/ipmitools/ipmipass" ],
                        }

#                        file { '/usr/sbin/megaclisas-status':
#                                ensure=> 'link',
#                                target=> '/usr/lib/nagios/plugins/check_megaclisas',
#                        }
                }
	}

}
