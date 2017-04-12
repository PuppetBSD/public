class teamcity::master inherits teamcity::params {

  include teamcity::install
  include teamcity::config
  include teamcity::service_master

  if $::teamcity::params::db_type != undef {
    include ::teamcity::db::install
    include ::teamcity::db::config
  }

  Class['teamcity::install'] ->
  Class['teamcity::config'] ->
  Class['teamcity::service_master']

}
