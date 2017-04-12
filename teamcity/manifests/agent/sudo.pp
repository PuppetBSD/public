class teamcity::agent::sudo inherits teamcity::params {

  $sudo_ensure = $::teamcity::params::add_agent_sudo ? {
    true    => 'present',
    default => 'absent',
  }

  file_line { '/etc/sudoers sudo for teamcity':
    ensure  => $sudo_ensure,
    path    => '/etc/sudoers',
    line    => '%teamcity ALL=(ALL) NOPASSWD: ALL',
    match   => ' *%teamcity +ALL=(ALL)( +NOPASSWD:)? +ALL *',
  }

}
