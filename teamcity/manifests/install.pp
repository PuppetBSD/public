class teamcity::install inherits teamcity::params  {

  # taken from params

  $teamcity_version               = $teamcity::params::teamcity_version
  $teamcity_base_url              = $teamcity::params::teamcity_base_url

  $db_type                        = $teamcity::params::db_type
  $jdbc_download_url              = $teamcity::params::jdbc_download_url

  $teamcity_data_path             = $teamcity::params::teamcity_data_path
  $teamcity_logs_path             = $teamcity::params::teamcity_logs_path

  # derived

  $use_download_url = regsubst($teamcity_base_url, '%%%VERSION%%%', $teamcity_version)
  $use_target_dir   = "/opt/teamcity-${teamcity_version}"

  include wget
  include java
  include systemd
  include teamcity::prepare

  Class['java'] -> Group['teamcity']


  file { "/opt/teamcity-${teamcity_version}":
    ensure  => 'directory',
    owner   => 'teamcity',
    group   => 'teamcity',
  } ->

  file { "/opt/teamcity":
    ensure  => 'link',
    target  => "/opt/teamcity-${teamcity_version}",
    before  => Archive["teamcity-${teamcity_version}"],
  }

  if $::teamcity::params::archive_provider == 'camptocamp' {
    archive { "teamcity-${teamcity_version}":
      ensure            => 'present',
      url               => $use_download_url,
      target            => $use_target_dir,
      src_target        => '/opt/teamcity-sources',
      follow_redirects  => true,
      checksum          => false,
      strip_components  => 1,
      user              => 'teamcity',
      before            => File[$teamcity_data_path],
    }
  } else {
    # must be puppet :)
    archive { "teamcity-${teamcity_version}":
      ensure          => present,
      path            => '/tmp/teamcity.tar.gz',
      extract         => true,
      source          => $use_download_url,
      extract_path    => $use_target_dir,
      creates         => $use_target_dir,
      checksum_verify => false,
      cleanup         => true,
      before            => File[$teamcity_data_path],
    }
  }

  file { [
    "${teamcity_data_path}",
    "${teamcity_data_path}/config",
    "${teamcity_data_path}/lib",
    "${teamcity_data_path}/lib/jdbc"]:
    ensure  => 'directory',
    owner   => 'teamcity',
    group   => 'teamcity',
  }

}
