# = Class teamcity::master
#
# Configures a teamcity master on the host.
#
#
# == Parameters
#
# [*authentication*]
# String, must be 'local' (default) or 'ldap'. If 'ldap' is set you have to
# provide the ldap_configuration parameter.
#
# [*ldap_configuration*]
# String. The contents of the ldap-config.properties file. If set to 'external'
# then the user is responsible for providing the file by himself.
#
class teamcity::params (
  $teamcity_version               = '9.1.3',
  $teamcity_base_url              = 'http://download.jetbrains.com/teamcity/TeamCity-%%%VERSION%%%.tar.gz',

  $authentication                 = 'local',
  $ldap_configuration             = undef,

  $add_agent_sudo                 = false,

  $db_type                        = undef,
  $db_host                        = undef,
  $db_port                        = undef,
  $db_name                        = undef,
  $db_user                        = undef,
  $db_pass                        = undef,

  # unused
  $db_admin_user                  = undef,
  $db_admin_pass                  = undef,

  $jdbc_download_url              = undef,
  $agent_download_url             = '%%%TC_MASTER%%%/update/buildAgent.zip',
  $agent_master_url               = undef,

  $teamcity_agent_path            = '/opt/teamcity_agent',
  $teamcity_data_path             = '/var/lib/teamcity',
  $teamcity_logs_path             = '/opt/teamcity/logs',

  $archive_provider               = 'camptocamp',

) {

  validate_re($authentication, '^(local|ldap)$',
    "profiles::teamcity_master::authentication must be one of 'local' or 'ldap'"
  )

  if $authentication == 'ldap' and $ldap_configuration == undef {
    fail('profiles::teamcity_master: if authentication is LDAP you have to provide $ldap_configuration')
  }

  validate_re($archive_provider, '^(camptocamp|puppet)$',
    "teamcity::params::archive_provider must be one of 'camptocamp'/'puppet'"
  )

}
