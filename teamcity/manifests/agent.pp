define teamcity::agent (
  $agent_name = $title,
  $master_url = undef,
  $port       = '9090',
) {

  include teamcity::params
  Class['teamcity::params'] -> Teamcity::Agent<||>

  include teamcity::agent::sudo

  # first, try to get it from the parameters class
  $use_master_url = $master_url ? {
    undef   => $::teamcity::params::agent_master_url,
    default => $master_url,
  }

  # ... then from hiera directly.
  #$use_master_url = $tmp ? {
  #  undef   => hiera('teamcity::params::master_url', undef),
  #  default => undef,
  #}

  if $use_master_url == undef {
    fail("Teamcity::Agent[${agent_name}]: Please set \$master_url or teamcity::param::agent_master_url")
  }


  # necessary includes

  include java
  include teamcity::prepare
  include systemd


  # install

  $tc_agent_path    = $::teamcity::params::teamcity_agent_path
  $download_url     = $::teamcity::params::agent_download_url
  $use_download_url = regsubst($download_url, '%%%TC_MASTER%%%', $use_master_url)
  $use_agent_path   = "${tc_agent_path}_${agent_name}"

  mkdir::p { $use_agent_path :
    owner   => 'teamcity',
    group   => 'teamcity',
    before  => Archive["teamcity-agent-${agent_name}"],
  }

  if $::teamcity::params::archive_provider == 'camptocamp' {
    archive { "teamcity-agent-${agent_name}":
      ensure            => 'present',
      url               => $use_download_url,
      target            => $use_agent_path,
      src_target        => '/opt/teamcity-sources',
      follow_redirects  => true,
      checksum          => false,
      user              => 'teamcity',
      extension         => 'zip',
    }
  } else {
    archive { "teamcity-agent-${agent_name}":
      ensure          => present,
      path            => "/tmp/teamcityagent-${agent_name}.zip",
      extract         => true,
      source          => $use_download_url,
      extract_path    => $use_agent_path,
      # because we do mkdir::p before, this would not work with the directory
      creates         => "${use_agent_path}/bin/agent.sh",
      user            => 'teamcity',
      checksum_verify => false,
      cleanup         => true,
    }
  }

  exec { "check agents' ${agent_name} presence":
    command => 'false',
    unless  => "test -f '${use_agent_path}/bin/agent.sh'",
    path    => '/usr/bin:/bin',
    require => Archive["teamcity-agent-${agent_name}"],

  } ->

  # yup, not done in the zip distribution. yeah, great.
  file { "${use_agent_path}/bin/agent.sh":
    ensure  => 'present',
    mode    => '0755',
  } ->


  # config

  exec { "create agent ${agent_name} buildAgent.dist":
    command   => 'cp buildAgent.dist.properties buildAgent.properties',
    cwd       => "${use_agent_path}/conf",
    path      => '/usr/bin:/bin',
    unless    => 'test -f buildAgent.properties',
    user      => 'teamcity',
  } ->

  file_line { "agent ${agent_name} server url":
    ensure  => 'present',
    path    => "${use_agent_path}/conf/buildAgent.properties",
    line    => "serverUrl=${use_master_url}",
    match   => '^ *#? *serverUrl *=.*',
  } ->

  file_line { "agent ${agent_name} own port":
    ensure  => 'present',
    path    => "${use_agent_path}/conf/buildAgent.properties",
    line    => "ownPort=${port}",
    match   => '^ *#? *ownPort *=.*',
  } ->

  file_line { "agent ${agent_name} own name":
    ensure  => 'present',
    path    => "${use_agent_path}/conf/buildAgent.properties",
    line    => "name=${agent_name}",
    match   => '^ *#? *name *=.*',
    before  => Service["teamcity-agent-${agent_name}"],
  }


  # service

  $start_command        = "${use_agent_path}/bin/agent.sh run"
  $stop_command         = "${use_agent_path}/bin/agent.sh stop"
  $kill_command         = "${use_agent_path}/bin/agent.sh stop force"
  $service_description  = "Teamcity build agent '${agent_name}'"

  file { "/etc/systemd/system/teamcity-agent-${agent_name}.service":
    ensure  => 'present',
    content => template('teamcity/systemd_teamcity.service.erb'),
    mode    => '0755',
  } ~>

  Exec['systemctl-daemon-reload'] ->

  service { "teamcity-agent-${agent_name}":
    ensure  => 'running',
    enable  => true,
    require => File["${use_agent_path}/bin/agent.sh"]
  }

}
