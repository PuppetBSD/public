# Define: nginx::resources::upstream::member
#
# Creates an upstream member inside the upstream block. Export this resource
# in all upstream member servers and collect them on the NGINX server.
#
#
# Requirements:
#   Requires storeconfigs on the Puppet Master to export and collect resources
#
#
# Parameters:
#   [*ensure*]                  - Enables or disables the specified member (present|absent)
#   [*upstream*]                - The name of the upstream resource
#   [*server*]                  - Hostname or IP of the upstream member server
#   [*port*]                    - Port of the listening service on the upstream member
#   [*upstream_fail_timeout*]   - Set the fail_timeout for the upstream. Default is 10 seconds
#
#
# Examples:
#
#   Exporting the resource on a upstream member server:
#
#   @@nginx::resource::upstream::member { $::fqdn:
#     ensure    => present,
#     upstream  => 'proxypass',
#     server    => $::ipaddress,
#     port      => 3000,
#   }
#
#
#   Collecting the resource on the NGINX server:
#
#   nginx::resource::upstream { 'proxypass':
#     ensure    => present,
#   }
#
define nginx::resource::upstream::member (
  $upstream,
  $server,
  $ensure                 = 'present',
  $port                   = 80,
  $upstream_fail_timeout  = '10s',
) {

  validate_re($ensure, '^(present|absent)$',
    "${ensure} is not supported for ensure. Allowed values are 'present' and 'absent'.")

  if is_string($port) {
    warning('DEPRECATION: String $port must be converted to an integer. Integer string support will be removed in a future release.')
  }
  elsif !is_integer($port) {
    fail('$port must be an integer.')
  }

  $ensure_real = $ensure ? {
    'absent' => absent,
    default  => present,
  }

  # Uses: $server, $port, $upstream_fail_timeout
  concat::fragment { "${upstream}_upstream_member_${name}":
    target  => "${::nginx::conf_dir}/conf.d/${upstream}-upstream.conf",
    order   => 40,
    content => template('nginx/conf.d/upstream_member.erb'),
  }
}
