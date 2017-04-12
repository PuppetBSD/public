# == Class: aptcacherng
#
# Applying `aptcacherng` to a node will configure the node to act as a
# caching proxy for apt (and other) package management systems.
#
# === Parameters
#
# [*packagename*]
#   Apt-cacher-ng package name.
#   (undef correspond to 'apt-cacher-ng' on Debian osfamily)
#   Defaults: undef
#
# [*cachedir*]
#   Change the default directory where apt-cacher-ng will store its cache.
#   Default: '/var/cache/apt-cacher-ng'
#
# [*logdir*]
#   Log directory of apt-cacher-ng.
#   (set empty to disable logging).
#   Default: '/var/log/apt-cacher-ng'
#
# [*supportdir*]
#   Place to look for additional configuration and resource
#   files if they are not found in the configuration directory.
#   Default: undef
#
# [*port*]
#   TCP (http) listen port. Set to 9999 to emulate apt-proxy.
#   (integer) Default: 3142
#
# [*bindaddress*]
#   Addresses or hostnames to listen on. Multiple addresses
#   must be separated by spaces.
#   (integer) Default: undef
#
# [*proxy*]
#   The specification of another proxy which shall be used for downloads.
#   Default: undef
#
# [*remap_lines*]
#   Repository remapping.
#   Default: undef
#
# [*reportpage*]
#   Virtual page accessible in a web browser to see statistics
#   and status information.
#   Default: acng-report.html
#
# [*socketpath*]
#   Socket file for accessing through local UNIX socket instead of TCP/IP.
#   Can be used with inetd bridge or cron client.
#   Default: undef
#
# [*unbufferlogs*]
#   Forces log file to be written to disk after every line
#   when set to 1. If 0, buffers are flushed when the client disconnects.
#   (integer) Default: undef
#
# [*verboselog*]
#   Set to 0 to store only type, time and transfer sizes,
#   and 1 -> client IP and relative local path are logged too
#   (integer) Default: undef
#
# [*foreground*]
#   Don't detach from the console
#   Default: undef
#
# [*pidfile*]
#   Store the pid of the daemon process therein
#   Default: undef
#
# [*offlinemode*]
#   Forbid outgoing connections, work around them or respond with 503 error
#   Default: undef
#
# [*forcemanaged*]
#   Forbid all downloads that don't run through preconfigured
#   backends (.where)
#   Default: undef
#
# [*extreshold*]
#   Days before considering an unreferenced file expired (to be deleted).
#   (integer) Default: 4
#
# [*exabortonproblems*]
#   Stop expiration when a critical problem appeared. Currently only failed
#   refresh of an index file is considered as critical.
#   (integer) Default: undef
#
# [*stupidfs*]
#   Replace some Windows/DOS-FS incompatible chars when storing
#   (integer) Default: undef
#
# [*forwardbtssoap*]
#   Experimental feature for apt-listbugs: pass-through SOAP requests and
#   responses to/from bugs.debian.org. If not set, default is true if
#   ForceManaged is enabled and false otherwise.
#   (integer) Default: undef
#
# [*dnscacheseconds*]
#   The daemon has a small cache for DNS data, to speed up resolution. The
#   expiration time of the DNS entries can be configured in seconds.
#   (integer) Default: undef
#
# [*maxstandbyconthreads*]
#   Max. count of connection threads kept ready (for faster response in the
#   future). Should be a sane value between 0 and average number of
#   connections, and depend on the amount of spare RAM.
#   (integer) Default: undef
#
# [*maxconthreads*]
#   Hard limit of active thread count for incoming connections, i.e.
#   operation is refused when this value is reached (below zero = unlimited).
#   Default: undef
#
# [*vfilepattern*]
#   Pigeonholing files with regular expressions (static/volatile). Can be
#   overridden here but not should not be done permanently because future
#   update of default settings would not be applied later.
#   Default: undef
#
# [*pfilepattern*]
# [*wfilepattern*]
#   Whitelist for expiration, file types not to be removed even when being
#   unreferenced. Default: many parts from VfilePattern where no parent index
#   exists or might be unknown.
#   Default: undef
#
# [*debug*]
#   Higher modes only working with the debug version
#   Warning, writes a lot into apt-cacher.err logfile
#   Value overwrites UnbufferLogs setting (aliased)
#   Default: undef
#
# [*exposeorigin*]
#   Usually, general purpose proxies like Squid expose the IP address of
#   the client user to the remote server using the X-Forwarded-For HTTP
#   header. This behaviour can be optionally turned on with the
#   Expose-Origin option.
#   Default: undef
#
# [*logsubmittedorigin*]
#   Usually, general purpose proxies like Squid expose the IP address
#   of the client user to the remote server using the X-Forwarded-For
#   HTTP header. This behaviour can be optionally turned on with the
#   Expose-Origin option.
#   Default: undef
#
# [*useragent*]
#   The version string reported to the peer, to be displayed as HTTP
#   client (and version) in the logs of the mirror.
#   Default: undef
#
# [*recompbz2*]
#   In some cases the Import and Expiration tasks might create fresh volatile
#   data for internal use by reconstructing them using patch files. This
#   by-product might be recompressed with bzip2 and with some luck the
#   resulting file becomes identical to the *.bz2 file on the server, usable
#   for APT clients trying to fetch the full .bz2 compressed version. Injection
#   of the generated files into the cache has however a disadvantage on
#   underpowered servers: bzip2 compression can create high load on the server
#   system and the visible download of the busy .bz2 files also becomes slower.
#   (integer) Default: undef
#
# [*networktimeout*]
#   Network timeout for outgoing connections.
#   (integer) Default: undef
#
# [*dontcacherequested*]
#   Sometimes it makes sense to not store the data in cache and just return the
#   package data to client as it comes in. DontCache parameters can enable this
#   behaviour for certain URL types. The tokens are extended regular
#   expressions that URLs are matched against.
#   Default: undef
#
# [*dontcacheresolved*]
#   DontCacheResolved is applied to URLs after mapping to the target server. If
#   multiple backend servers are specified then it's only matched against the
#   download link for the FIRST possible source (due to implementation limits)
#   Default: undef
#
# [*dontcache*]
#   DontCache directive sets (overrides) both, DontCacheResolved and
#   DontCacheRequested.
#   Default: undef
#
# [*dirperms*]
#   Default permission set of freshly created directories, as octal numbers
#   Default: undef
#
# [*fileperms*]
#   Default permission set of freshly created files, as octal numbers
#   Default: undef
#
# [*localdirs*]
#   It's possible to use use apt-cacher-ng as a regular web server with
#   limited feature set, i.e. including directory browsing and download
#   of any file; excluding sorting, mime types/encodings, CGI execution,
#   index page redirection and other funny things.
#   Default: undef
#
# [*precachefor*]
#   Precache a set of files referenced by specified index files. This
#   can be used to create a partial mirror usable for offline work.
#   There are certain limits and restrictions on the path specification,
#   see manual for details. A list of (maybe) relevant index files could
#   be retrieved via "apt-get --print-uris update" on a client machine.
#   Default: undef
#
# [*requestappendix*]
#   Arbitrary set of data to append to request headers sent over the wire.
#   Should be a well formated HTTP headers part including newlines
#   (DOS style) which can be entered as escape sequences (\r\n).
#   Default: undef
#
# [*connectproto*]
#   Specifies the IP protocol families to use for remote connections.
#   Order does matter, first specified are considered first.
#   Possible values: v6 v4
#   Default: undef
#
# [*keepextraversions*]
#   Regular expiration algorithm finds package files which are no longer
#   listed in any index file and removes them of them after a safety period.
#   This option allows to keep more versions of a package in the cache after
#   safety period is over.
#   Default: undef
#
# [*usewrap*]
#   Optionally uses TCP access control provided by libwrap. Daemon name is
#   apt-cacher-ng. Default if not set: decided on startup by looking for
#   explicit mentioning of apt-cacher-ng in /etc/hosts.allow or
#   /etc/hosts.deny files.
#   (integer) Default: undef
#
# [*freshindexmaxage*]
#   If many machines from the same local network attempt to update index files
#   (apt-get update) at nearly the same time, the known state of these index
#   file is temporarily frozen and multiple requests receive the cached
#   response without contacting the server. This parameter (in seconds)
#   specifies the length of this period before the files are considered
#   outdated. Setting it too low transfers more data and increases remote
#   server load, setting it too high (more than a couple of minutes) increases
#   the risk of delivering inconsistent responses to the clients.
#   (integer) Default: undef
#
# [*allowuserports*]
#   Usually the users are not allowed to specify custom TCP ports of remote
#   mirrors in the requests, only the default HTTP port can be used (instead,
#   proxy administrator can create Remap- rules with custom ports). This
#   restriction can be disabled by specifying a list of allowed ports or 0 for
#   any port.
#   (integer) Default: undef
#
# [*redirmax*]
#   Normally the HTTP redirection responses are forwarded to the original
#   caller (i.e. APT) which starts a new download attempt from the new URL.
#   This solution is ok for client configurations with proxy mode but doesn't
#   work well with configurations using URL prefixes. To work around this the
#   server can restart its own download with another URL. However, this might
#   be used to circumvent download source policies by malicious users. The
#   RedirMax option specifies how many such redirects the server should follow
#   per request, 0 disables the internal redirection. If not set, default value
#   is 0 if ForceManaged is used and 5 otherwise.
#   (integer) Default: undef
#
# [*vfileuserangeops*]
#   There some broken HTTP servers and proxy servers in the wild which don't
#   support the If-Range header correctly and return incorrect data when the
#   contents of a (volatile) file changed. Setting VfileUseRangeOps to zero
#   disables Range-based requests while retrieving volatile files, using
#   If-Modified-Since and requesting the complete file instead. Setting it to a
#   negative value removes even If-Modified-Since headers.
#   Default: undef
#
# [*auth_username*]
#   Basic authentication username required to visit pages with
#   administrative functionality.
#   Default: undef
#
# [*auth_password*]
#   Basic authentication password required to visit pages with
#   administrative functionality.
#   Default: undef
#
# [*passthroughpattern*]
#   Allow data pass-through mode for certain hosts when requested by
#   the client using a CONNECT request. This is particularly useful to
#   allow access to SSL sites (https proxying). The string is a
#   regular expression which should cover the server name with port
#   and must be correctly formated and terminated.  Default: undef
#
# [*max_files*]
#   Sets Linux security nofile limit
#   Default: undef
#
# === Examples
#
#  class { aptcacherng:
#    cachedir => '/data/apt-cache'
#  }
#
# === Authors
#
# Mark Hellewell <mark.hellewell@gmail.com>
#
# === Copyright
#
# Copyright 2013 Mark Hellewell.
#
class aptcacherng (
  $packagename          = undef,
  $cachedir             = '/var/cache/apt-cacher-ng',
  $logdir               = '/var/log/apt-cacher-ng',
  $supportdir           = undef,
  $port                 = '3142',
  $bindaddress          = undef,
  $proxy                = undef,
  $remap_lines          = undef,
  $reportpage           = 'acng-report.html',
  $socketpath           = undef,
  $unbufferlogs         = undef,
  $verboselog           = undef,
  $foreground           = undef,
  $pidfile              = undef,
  $offlinemode          = undef,
  $forcemanaged         = undef,
  $extreshold           = 4,
  $exabortonproblems    = undef,
  $stupidfs             = undef,
  $forwardbtssoap       = undef,
  $dnscacheseconds      = undef,
  $maxstandbyconthreads = undef,
  $maxconthreads        = undef,
  $vfilepattern         = undef,
  $pfilepattern         = undef,
  $wfilepattern         = undef,
  $debug                = undef,
  $exposeorigin         = undef,
  $logsubmittedorigin   = undef,
  $useragent            = undef,
  $recompbz2            = undef,
  $networktimeout       = undef,
  $dontcacherequested   = undef,
  $dontcacheresolved    = undef,
  $dontcache            = undef,
  $dirperms             = undef,
  $fileperms            = undef,
  $localdirs            = undef,
  $precachefor          = undef,
  $requestappendix      = undef,
  $connectproto         = undef,
  $keepextraversions    = undef,
  $usewrap              = undef,
  $freshindexmaxage     = undef,
  $allowuserports       = undef,
  $redirmax             = undef,
  $vfileuserangeops     = undef,
  $passthroughpattern   = undef,
  $auth_username        = undef,
  $auth_password        = undef,
  $service_ensure       = running,
  $service_enable       = true,
  $max_files            = undef,
  # TODO support an argument for this
  # http://www.unix-ag.uni-kl.de/~bloch/acng/html/howtos.html#howto-importdisk
  ) {
  include aptcacherng::params

  # if a special alternative packagename was provided then use it,
  # otherwise use the package name determined by the params class.
  if $packagename {
    $package = $packagename
  } else {
    $package = $aptcacherng::params::package
  }

  package {'apt-cacher-ng':
    ensure => installed,
    name   => $package,
  }

  File {
    require => Package['apt-cacher-ng'],
    before  => Service['apt-cacher-ng'],
  }

  file {$cachedir:
    ensure  => directory,
    owner   => 'apt-cacher-ng',
    group   => 'apt-cacher-ng',
    mode    => '2755',
  }

  file {$logdir:
    ensure  => directory,
    owner   => 'apt-cacher-ng',
    group   => 'apt-cacher-ng',
    mode    => '2755',
  }

  file {'/etc/apt-cacher-ng/acng.conf':
    content => template('aptcacherng/acng.conf.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package['apt-cacher-ng'],
  }

  file {'/etc/apt-cacher-ng/zz_debconf.conf':
    ensure => absent,
  }

  if $max_files != undef {
    file {'/etc/security/limits.d/apt-cacher-ng':
      content => template('aptcacherng/apt-cacher-ng_limits.erb'),
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
    }
  } else {
    file {'/etc/security/limits.d/apt-cacher-ng':
      ensure => absent
    }
  }

  service {'apt-cacher-ng':
    ensure    => $service_ensure,
    enable    => $service_enable,
    subscribe => [File['/etc/apt-cacher-ng/acng.conf'],
                  File['/etc/apt-cacher-ng/zz_debconf.conf']],
  }

  if $auth_username {
    file {'/etc/apt-cacher-ng/security.conf':
      content => template('aptcacherng/security.conf.erb'),
      owner   => 'apt-cacher-ng',
      group   => 'apt-cacher-ng',
      mode    => '0600',
    }
  }

}
