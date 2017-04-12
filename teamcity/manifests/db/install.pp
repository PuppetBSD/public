class teamcity::db::install inherits ::teamcity::params {

  $db_type                        = $::teamcity::params::db_type

  # for the template!
  $db_host                        = $::teamcity::params::db_host
  $db_port                        = $::teamcity::params::db_port
  $db_name                        = $::teamcity::params::db_name
  $db_user                        = $::teamcity::params::db_user
  $db_pass                        = $::teamcity::params::db_pass

  # unused
  $db_admin_user                  = $::teamcity::params::db_admin_user
  $db_admin_pass                  = $::teamcity::params::db_admin_pass

  $jdbc_download_url              = $::teamcity::params::jdbc_download_url
  $teamcity_data_path             = $::teamcity::params::teamcity_data_path


  # variable definitions

  $use_jdbc_download_url = $jdbc_download_url ? {
    undef => $db_type ? {
      'postgresql'  => 'https://jdbc.postgresql.org/download/postgresql-9.4-1205.jdbc41.jar',
    },
    default => $jdbc_download_url,
  }

  $tmp              = split($use_jdbc_download_url, "[/\\\\]")
  $jdbc_filename    = $tmp[-1]


  # go

  File["${teamcity_data_path}/lib/jdbc"] ->

  wget::fetch { $use_jdbc_download_url:
    destination => "${teamcity_data_path}/lib/jdbc/${jdbc_filename}",
    user        => 'teamcity',
  } ~>

  Service['teamcity']

}
