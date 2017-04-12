class teamcity::service_master inherits teamcity::params  {

  include systemd

  $start_command = '/opt/teamcity/bin/teamcity-server.sh run'
  $stop_command  = '/opt/teamcity/bin/teamcity-server.sh stop 30 -force'
  $kill_command  = '/opt/teamcity/bin/teamcity-server.sh stop 5  -force'

  $service_description = "Teamcity master service"

  file { '/etc/systemd/system/teamcity.service':
    ensure  => 'present',
    content => template('teamcity/systemd_teamcity.service.erb'),
    mode    => '0755',
  } ~>

  Exec['systemctl-daemon-reload'] ->

  service { 'teamcity':
    ensure  => 'running',
    enable  => true,
  }

}