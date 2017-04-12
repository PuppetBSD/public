# == Type cix_ldap::schema_file
#
# Import extra schema files from the master
#
define cix_ldap::schema_file ($directory,
  $schema = $title,
  $source = undef,
  $source_directory = "puppet://${server}/modules/${module_name}",
) {
  if $source {
    $schema_source = $source
  } else {
    $schema_source = "${source_directory}/${schema}.schema"
  }

  file { "${directory}/${schema}.schema":
    owner  => 0,
    group  => 0,
    mode   => '0644',
    source => [ "$schema_source", ]
#	source => [ "puppet:///${server}/modules/${module_name}/openssh-lpk-openldap.schema", ]
  }

#        file { "${directory}/${schema}.schema":
#                source => [ "puppet://${server}/modules/${module_name}/openssh-lpk-openldap.schema" ],
#                mode => '0644',
#        }


}
