class teamcity::db::config inherits ::teamcity::params {

  $db_type = $::teamcity::params::db_type
  $db_host = $::teamcity::params::db_host
  $db_port = $::teamcity::params::db_port
  $db_name = $::teamcity::params::db_name
  $db_user = $::teamcity::params::db_user
  $db_pass = $::teamcity::params::db_pass


  file { "${::teamcity::params::teamcity_data_path}/config/database.properties":
    ensure  => 'present',
    content => template("teamcity/${db_type}.database.properties.erb")
  } ~>

  Service['teamcity']

}
