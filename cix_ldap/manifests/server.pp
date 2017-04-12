# == Class: cix_ldap::server
#
#  This class manages the installation and configuration of an OpenLDAP Server
#
# === Parameters
#
# [*suffix*]
#   The domain for which the LDAP server provides information for.
#
# [*rootdn*]
#   The administrative user which has root access to the database schema.
#
# [*rootpw*]
#   The password for the rootdn administrative user.
#
# [*config_file*]
#   Location of the server configuration file.
#
# [*config_file_mode*]
#   Permissions of the server configuration file.
#
# [*default_file*]
#   Location of the OS OpenLDAP server defaults file.
#
# [*default_file_mode*]
#   Permission of the OS OpenLDAP server defaults file.
#
# [*db_config_file*]
#   Location of the DB_CONFIG file.
#
# [*db_config_file_mode*]
#   Permission of the DB_CONFIG file.
#
# [*directory*]
#   Path to where the slapd database files should be stored.
#
# [*directory_mode*]
#   Permissions of the path to where the slapd database files should be stored.
#
# [*ldapowner*]
#   The owner of the slapd and database configuration files.
#
# [*ldapgroup*]
#   The group of the slapd and database configuration files.
#
# [*backend*]
#   Database backend to use.
#
# [*log_level*]
#   Daemon logging level, see http://www.openldap.org/doc/admin24/slapdconfig.html.
#
# [*schemas*]
#   An array of schema files which should be loaded in.
#
# [*extra_schemas*]
#   An array of schema files which should be importe from the master and loaded in.
#
# [*run_directory*]
#   Directory where OpenLDAP stores run time information, i.e. PID file.
#
# [*run_directory_mode*]
#   Permissions of the directory where OpenLDAP stores run time information, i.e. PID file.
#
# [*schema_directory*]
#   Directory to import the extra schema files into.
#
# [*schema_directory_mode*]
#   Permissions of the directory to import the extra schema files into.
#
# [*schema_source_directory*]
#   Directory to import the extra schema files from, usually a puppet:///files source.
#
# [*modules*]
#   An array of modules which should be loaded in.
#
# [*indexes*]
#   An array of indexes which should be created in the database.
#
# [*overlays*]
#   An array of overlays which should be added to the database.
#
# [*memberof_group_oc*]
#   The value <group-oc> is the name of the objectClass that triggers the reverse group membership update. It defaults to groupOfNames.
#
# [*memberof_member_ad*]
#   The value <member-ad> is the name of the attribute that contains the names of the members in the group objects; it must be DN-valued. It defaults to member.
#   for more information man slapo-memberof
#
# [*refint_attributes*]
#   Attributes for refint overlay.
#
# [*sync_rid*]
#   Replication ID to use for syncrepl replication.
#
# [*sync_provider*]
#   Activate syncrepl replication if set and configure this URI as provider for this consumer.
#
# [*sync_master_uri*]
#   Refer clients to this server for write operations if we're configured as consumer (updateref).
#
# [*sync_searchbase*]
#   Replicate beginning at this search base on the provider.
#
# [*sync_type*]
#   Use this replication type (refreshOnly|refreshAndPersist).
#
# [*sync_interval*]
#   Synchronization interval.
#
# [*sync_retry*]
#   Synchronization retries
#
# [*sync_filter*]
#   Search filter for synchronization.
#
# [*sync_scope*]
#   Search scope for synchronization.
#
# [*sync_attrs*]
#   Attribute list for synchronization.
#
# [*sync_schemachecking*]
#   Whether to do schema checking when synchronizing. (boolean)
#
# [*sync_bindmethod*]
#   Synchronization bind method.
#
# [*sync_binddn*]
#   Bind DN on provider for syncrepl replication.
#
# [*sync_credentials*]
#   Simple bind credentials for provider.
#
# [*sync_mirrormode*]
#   Enable mirror mode replication.
#
# [*sync_saslmech*]
#   SASL mechanism for syncrepl replication.
#
# [*sync_tls_cert*]
#   X.509 client certificate for syncrepl replication.
#
# [*sync_tls_key*]
#   X.509 private key for syncrepl replication.
#
# [*sync_tls_cacert*]
#   X.509 ca certificate for syncrepl replication.
#
# [*sync_tls_reqcert*]
#   requirement of server certificat verification
#
# [*slapd_services*]
#   to specify the interface you listen on.
#   ex : ldap://127.0.0.1:389/ ldap://10.2.0.5:389/ to listen only on to ip
#   Default with ssl :    ldap:/// ldaps:/// ldapi:///
#   Default without ssl : ldap:/// ldapi:///
#
# [*ssl*]
#   Whether the server should listen on port 636 (SSL).
#   Default: false
#
# [*ssl_cacert*]
#   Path to the certificate authority file for the LDAP SSL certificate.
#
# [*ssl_cert*]
#   Path to the SSL certificate file.
#
# [*ssl_key*]
#   Path to the SSL certificate key.
#
# [*ssl_ciphersuite*]
#   specify tls ciphersuite.
#
# [*ssl_verify_client*]
#   Whether and how to verify the client.
#
# [*kerberos*]
#   Whether to use kerberos.
#
# [*krb5_keytab*]
#   Keytab file to configure for the server to use for accepting kerberized
#   client connections.
#
# [*krb5_ticket_cache*]
#   Ticket cache file to configure for the server to use for establishing
#   kerberized LDAP connections to other servers, e.g. via the ldap backend or
#   syncrepl overlay.
#
# [*authz_regexp*]
#   An array of authz-regexp config lines
#
# [*access*]
#   ACLs to configure for the server. An array of hashes of arrays of hashes
#   describing the ACLs:
#
#   $access = [
#     { 'to what' => [
#       { <implicit> "uidNumber=0... LDAPI" => "$access_for_ldapi_rootdn" },
#       { 'by who' => 'access' },
#       { 'by who' => 'access' },
#       { <implicit> "*" => "none" } ] },
#     { 'to what' => [ ... ] },
#     <implicit> { '*' => [
#       { <implicit> "uidNumber=0... LDAPI" => "$access_for_ldapi_rootdn" },
#       { <implicit> "*" => "none" } ] },
#   ]
#
#   'access' can be a special placeholder @@writeable_on_sync_provider_only@@
#   which will by default be 'write' on the syncrepl provider and 'read' on any
#   consumer.
#
#   default:
#   $access = [
#     { 'attrs=userPassword,shadowLastChange' => [
#       { 'self' => '@@writeable_on_sync_provider_only@@' },
#       { 'anonymous' => 'auth' },
#     ] },
#     { 'attrs=objectClass,cn,uid,uidNumber,gidNumber,gecos,homeDirectory,loginShell,member,memberUid,entry' => [
#       { '*' => 'read' },
#     ] },
#   ]
#
# [*disable_safe_default_acls*]
#   Fully disable any safe defaults for ACLs so they can be fully customised
#   using the access hash and no superfluous fallbacks that are never used get
#   added (Default: false).
#
# [*access_writeable_on_sync_provider_only*]
#   Can provide an alternative value for access the
#   @@writeable_on_sync_provider_only@@ placeholder in ACLs. Since this can be
#   overridden using e.g. the hiera lookup hierarchy the logic for setting this
#   to what can be as complex as necessary. Default: write on provider, read on
#   any consumer.
#
# [*access_for_ldapi_rootdn*]
#   What access to grant to the LDAPI access DN. Default: write.
#
# [*dynconfig_directory*]
#   Path to the slapd.d cn=config backend directory.
#
# [*purge_dynconfig_directory*]
#   Whether to delete the cn=config backend directory to make sure that
#   slapd.conf is used. Default: false.
#
# [*config*]
#   Whether the config database should be built (cn=config).
#
# [*configdn*]
#   The root dn for the config database (Default: rootdn).
#
# [*configpw*]
#   The password for the configdn user (Default: rootpw).
#
# [*monitor*]
#   Whether the monitor database should be built (cn=Monitor).
#
# [*monitordn*]
#   The root dn for the monitor database (Default: rootdn).
#
# [*monitorpw*]
#   The password for the monitordn user (Default: rootpw).
#
# [*bind_anon*]
#   Allow anonymous (unauthenticated) binding to the LDAP server.
#   Default: false
#
# [*bind_v2*]
#   Whether to support LDAPv2.
#   Default: true
#
# [*sizelimit*]
#   The maximum number of entries to return  from  a  search operation.
#   Default: 500
#
# [*timelimit*]
#   The maximum number of seconds (in real time) slapd will spend answering
#   a search request.
#   Default: 3600
#
# === Examples
#
#  class { 'ldap::server':
#    suffix => 'dc=example,dc=com',
#    rootdn => 'cn=admin,dc=example,dc=com',
#    rootpw => 'llama',
#  }
#
class cix_ldap::server (
  $suffix,
  $rootdn,
  $rootpw           = undef,
  $configdn         = undef,
  $configpw         = undef,
  $monitordn        = undef,
  $monitorpw        = undef,
  $directory        = $cix_ldap::params::server_directory,
  $directory_mode   = $cix_ldap::params::server_directory_mode,
  $backend          = $cix_ldap::params::server_backend,
  $log_level        = $cix_ldap::params::server_log_level,
  $schemas          = $cix_ldap::params::server_schemas,
  $extra_schemas    = $cix_ldap::params::server_extra_schemas,
  $schema_directory = $cix_ldap::params::server_schema_directory,
  $schema_directory_mode   = $cix_ldap::params::server_schema_directory_mode,
  $schema_source_directory = $cix_ldap::params::server_schema_source_directory,
  $run_directory           = $cix_ldap::params::server_run_directory,
  $run_directory_mode      = $cix_ldap::params::server_run_directory_mode,
  $modules          = $cix_ldap::params::server_modules,
  $indexes          = $cix_ldap::params::server_indexes,
  $overlays         = $cix_ldap::params::server_overlays,
  $sync_rid            = $cix_ldap::params::server_sync_rid,
  $sync_provider       = $cix_ldap::params::server_sync_provider,
  $sync_master_uri     = undef,
  $sync_searchbase     = undef,
  $sync_type           = $cix_ldap::params::server_sync_type,
  $sync_interval       = $cix_ldap::params::server_sync_interval,
  $sync_retry          = $cix_ldap::params::server_sync_retry,
  $sync_filter         = $cix_ldap::params::server_sync_filter,
  $sync_scope          = $cix_ldap::params::server_sync_scope,
  $sync_attrs          = $cix_ldap::params::server_sync_attrs,
  $sync_schemachecking = $cix_ldap::params::server_sync_schemachecking,
  $sync_bindmethod     = $cix_ldap::params::server_sync_bindmethod,
  $sync_binddn         = $cix_ldap::params::server_sync_binddn,
  $sync_credentials    = $cix_ldap::params::server_sync_credentials,
  $sync_mirrormode     = $cix_ldap::params::server_sync_mirrormode,
  $sync_saslmech       = $cix_ldap::params::server_sync_saslmech,
  $sync_tls_cert       = $cix_ldap::params::server_sync_tls_cert,
  $sync_tls_key        = $cix_ldap::params::server_sync_tls_key,
  $sync_tls_cacert     = $cix_ldap::params::server_sync_tls_cacert,
  $sync_tls_reqcert    = $cix_ldap::params::server_sync_tls_reqcert,
  $access           = $cix_ldap::params::server_access,
  $disable_safe_default_acls = $cix_ldap::params::server_disable_safe_default_acls,
  $access_writeable_on_sync_provider_only = undef,
  $access_for_ldapi_rootdn = undef,
  $slapd_services   = $cix_ldap::params::server_slapd_services,
  $ssl              = $cix_ldap::params::server_ssl,
  $ssl_cacert       = $cix_ldap::params::server_ssl_cacert,
  $ssl_cert         = $cix_ldap::params::server_ssl_cert,
  $ssl_key          = $cix_ldap::params::server_ssl_key,
  $ssl_ciphersuite  = $cix_ldap::params::server_ssl_ciphersuite,
  $ssl_verify_client = $cix_ldap::params::server_ssl_verify_client,
  $kerberos          = $cix_ldap::params::server_kerberos,
  $krb5_keytab       = $cix_ldap::params::server_krb5_keytab,
  $krb5_ticket_cache = $cix_ldap::params::server_krb5_ticket_cache,
  $authz_regexp     = $cix_ldap::params::server_authz_regexp,
  $config           = $cix_ldap::params::config,
  $monitor          = $cix_ldap::params::monitor,
  $bind_anon        = $cix_ldap::params::server_bind_anon,
  $bind_v2          = $cix_ldap::params::server_bind_v2,
  $package_name     = $cix_ldap::params::server_package_name,
  $package_ensure   = $cix_ldap::params::server_package_ensure,
  $service_manage   = $cix_ldap::params::server_service_manage,
  $service_name     = $cix_ldap::params::server_service_name,
  $service_enable   = $cix_ldap::params::server_service_enable,
  $service_ensure   = $cix_ldap::params::server_service_ensure,
  $config_directory = $cix_ldap::params::ldap_config_directory,
  $dynconfig_directory = $cix_ldap::params::server_dynconfig_directory,
  $purge_dynconfig_directory = $cix_ldap::params::server_purge_dynconfig_directory,
  $config_file      = $cix_ldap::params::server_config_file,
  $config_file_mode = $cix_ldap::params::server_config_file_mode,

  $config_template     = $cix_ldap::params::server_config_template,
  $default_file        = $cix_ldap::params::server_default_file,
  $default_file_mode   = $cix_ldap::params::server_default_file_mode,
  $default_template    = $cix_ldap::params::server_default_template,
  $db_config_file      = $cix_ldap::params::server_db_config_file,
  $db_config_file_mode = $cix_ldap::params::server_db_config_file_mode,
  $db_config_template  = $cix_ldap::params::server_db_config_template,
  $ldapowner           = $cix_ldap::params::ldapowner,
  $ldapgroup           = $cix_ldap::params::ldapgroup,
  $memberof_group_oc   = $cix_ldap::params::server_memberof_group_oc,
  $memberof_member_ad  = $cix_ldap::params::server_memberof_member_ad,
  $refint_attributes   = $cix_ldap::params::server_refint_attributes,
  $sizelimit           = $cix_ldap::params::server_sizelimit,
  $timelimit           = $cix_ldap::params::server_timelimit

) inherits cix_ldap::params {

  include stdlib

  validate_string($suffix)
  validate_string($rootdn)
  validate_string($rootpw)
  validate_absolute_path($directory)
  validate_re($backend, ['bdb', 'hdb', 'mdb'])
  validate_string($log_level)
  validate_array($schemas)
  validate_array($extra_schemas)
  validate_absolute_path($schema_directory)
  validate_absolute_path($config_directory)
  validate_string($schema_source_directory)
  validate_bool($purge_dynconfig_directory)

  if ($purge_dynconfig_directory) {
    validate_absolute_path($dynconfig_directory)
  }
  validate_array($modules)
  validate_array($indexes)
  validate_array($overlays)

  validate_bool($ssl)
  if $ssl == true {
    validate_absolute_path($ssl_cacert)
    # RedHat is linked against Mozilla NSS.
    # $ssl_ca is pointing to the cert db directory, /etc/openldap/certs
    # $ssl_cert is the name of the server certificate in that db, "OpenLDAP Server"
    # $ssl_key is file containing the password for the db, /etc/openldap/certs/password
    if $::osfamily != 'RedHat' {
      validate_absolute_path($ssl_cert)
    }
    validate_absolute_path($ssl_key)
    if $ssl_ciphersuite {
      validate_string($ssl_ciphersuite)
    }
    if $ssl_verify_client {
      # use tr[u]e re to work around lint warning "quoted boolean value found"
      validate_re($ssl_verify_client, ['never', 'allow', 'try', 'demand', 'hard', 'tr[u]e'])
    }
  }

  validate_bool($kerberos)
  if $kerberos {
    validate_string($krb5_keytab)
    validate_string($krb5_ticket_cache)
  }
  if $authz_regexp {
    validate_array($authz_regexp)
  }

  validate_bool($config)
  validate_bool($monitor)

  validate_bool($bind_anon)
  validate_bool($bind_v2)

  if $sync_provider {
    validate_string($sync_provider)
    if !is_integer($sync_rid) {
      fail('sync_rid must be an integer!')
    }
  }
  if $sync_type {
    validate_string($sync_type)
  }
  if $sync_interval {
    validate_string($sync_interval)
  }
  if $sync_retry {
    validate_string($sync_retry)
  }
  if $sync_filter {
    validate_string($sync_filter)
  }
  if $sync_scope {
    validate_string($sync_scope)
  }
  if $sync_attrs {
    validate_array($sync_attrs)
  }
  if $sync_schemachecking {
    validate_string($sync_schemachecking)
  }
  if $sync_bindmethod {
    validate_string($sync_bindmethod)
  }
  if $sync_credentials {
    validate_string($sync_credentials)
  }
  if $sync_mirrormode {
    validate_string($sync_mirrormode)
  }
  if $slapd_services {
    validate_string($slapd_services)
  }
  if $sync_saslmech {
    validate_string($sync_saslmech)
  }
  if $sync_tls_cert {
    validate_string($sync_tls_cert)
  }
  if $sync_tls_key {
    validate_string($sync_tls_key)
  }
  if $sync_tls_cacert {
    validate_string($sync_tls_cacert)
  }
  if $sync_tls_reqcert {
    validate_string($sync_tls_reqcert)
  }

  if $memberof_group_oc {
    validate_string($memberof_group_oc)
  }
  if $memberof_member_ad {
    validate_string($memberof_member_ad)
  }
  if $refint_attributes {
    validate_string($refint_attributes)
  }

  # use sync provider as master uri if not explicitly set
  $sync_master_uri_cfg = $sync_master_uri ? {
    default => $sync_master_uri,
    undef => $sync_provider,
  }
  if $sync_master_uri_cfg {
    validate_string($sync_master_uri_cfg)
  }

  # use suffix for sync searchbase if not given explicitly as parameter
  $sync_searchbase_cfg = $sync_searchbase ? {
    default => $sync_searchbase,
    undef => $suffix,
  }
  if $sync_searchbase_cfg {
    validate_string($sync_searchbase_cfg)
  }

  validate_array($access)
  validate_bool($disable_safe_default_acls)

  # if sync provider is given, make access readonly by default but allow override
  # via parameter using e.g. hiera lookup hierarchy
  $access_writeable_on_sync_provider_only_cfg =
    $access_writeable_on_sync_provider_only ? {
    default => $access_writeable_on_sync_provider_only,
    undef => $sync_provider ? {
      default => 'read',
      undef => 'write',
    }
  }
  if $access_writeable_on_sync_provider_only_cfg {
    validate_string($access_writeable_on_sync_provider_only_cfg)
  }

  # use what was determined for consumer writeablility above for ldap root
  # access by default but allow override via parameter
  $access_for_ldapi_rootdn_cfg = $access_for_ldapi_rootdn ? {
    default => $access_for_ldapi_rootdn,
    undef => $access_writeable_on_sync_provider_only_cfg,
  }
  if $access_for_ldapi_rootdn_cfg {
    validate_string($access_for_ldapi_rootdn_cfg)
  }

  anchor { 'cix_ldap::server::begin': } ->
  class { '::cix_ldap::server::install': } ->
  class { '::cix_ldap::server::config': } ~>
  class { '::cix_ldap::server::service': } ->
  anchor { 'cix_ldap::server::end': }
}
