class rtorrent::setenv {

#	exec { "set_lang":
#		command => "export LANG=en_US.UTF-8",
#	}

#	Exec { environment => [ "LANG=en_US.UTF-8" ] }

#    exec { 'set_lang' :
#     command => "/bin/sh -c \"export LANG=en_US.UTF-8\"",
#   }

}
