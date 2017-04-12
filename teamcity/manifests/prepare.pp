class teamcity::prepare inherits teamcity::params  {

  group { 'teamcity':
    ensure  => 'present',
    gid     => '2158',
  } ->

  user { 'teamcity':
    ensure  => 'present',
    gid     => 'teamcity',
    uid     => '2158',
  }

  file { '/opt/teamcity-sources':
    ensure  => 'directory',
    owner   => 'teamcity',
    group   => 'teamcity',
  }

}