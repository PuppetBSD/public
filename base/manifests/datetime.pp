class base::datetime {

#	class { 'timezone': }
#	class { 'ntp': }

class { 'timezone': }
#    timezone => 'Europe/Moscow',
#}


}
