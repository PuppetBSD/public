# == Define consul::check
#
# Sets up a Consul healthcheck
# http://www.consul.io/docs/agent/checks.html
#
# == Parameters
#
# [*ensure*]
#   Define availability of check. Use 'absent' to remove existing checks.
#   Defaults to 'present'
#
# [*http*]
#   HTTP endpoint for the service healthcheck
#
# [*id*]
#   The id for the check (defaults to $title)
#
# [*interval*]
#   Value in seconds for the interval between runs of the check
#
# [*notes*]
#   Human readable description of the check
#
# [*script*]
#   Full path to the location of the healthcheck script. Must be nagios
#   compliant with regards to the return codes.
#
# [*service_id*]
#   An optional service_id to match this check against
#
# [*status*]
#   The default state of the check when it is registered against a consul
#   agent. Should be either "critical" or "passing"
#
# [*tcp*]
#   The IP/hostname and port for the service healthcheck. Should be in
#   'hostname:port' format.
#
# [*timeout*]
#   A timeout value for HTTP request only
#
# [*token*]
#   ACL token for interacting with the catalog (must be 'management' type)
#
# [*ttl*]
#   Value in seconds before the http endpoint considers a failing healthcheck
#   to be "HARD" down.
#
define consul::check(
  $ensure     = present,
  $http       = undef,
  $id         = $title,
  $interval   = undef,
  $notes      = undef,
  $script     = undef,
  $service_id = undef,
  $status     = undef,
  $tcp        = undef,
  $timeout    = undef,
  $token      = undef,
  $ttl        = undef,
) {
  include consul

  $basic_hash = {
    'id'         => $id,
    'name'       => $name,
    'ttl'        => $ttl,
    'http'       => $http,
    'script'     => $script,
    'tcp'        => $tcp,
    'interval'   => $interval,
    'timeout '   => $timeout,
    'service_id' => $service_id,
    'notes'      => $notes,
    'token'      => $token,
    'status'     => $status,
  }

  $check_hash = {
    check => delete_undef_values($basic_hash)
  }

  consul_validate_checks($check_hash[check])

  $escaped_id = regsubst($id,'\/','_','G')
  File[$::consul::config_dir] ->
  file { "${consul::config_dir}/check_${escaped_id}.json":
    ensure  => $ensure,
    owner   => $::consul::user,
    group   => $::consul::group,
    mode    => $::consul::config_mode,
    content => consul_sorted_json($check_hash, $::consul::pretty_config, $::consul::pretty_config_indent),
  } ~> Class['consul::reload_service']
}
