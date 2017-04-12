# Class: jenkins::params
#
#
class jenkins::params {
  $version               = 'installed'
  $lts                   = true
  $repo                  = true
  $direct_download       = undef
  $service_enable        = true
  $service_ensure        = 'running'
  $install_java          = true
  $swarm_version         = '2.2'
  $default_plugins_host  = 'https://updates.jenkins.io'
  $port                  = 8080
  $prefix                = ''
  $cli_tries             = 10
  $cli_try_sleep         = 10
  $package_cache_dir     = '/var/cache/jenkins_pkgs'
  $package_name          = 'jenkins'

  $manage_datadirs = true
  $localstatedir   = '/var/lib/jenkins'

  $manage_user  = true
  $user         = 'jenkins'
  $manage_group = true
  $group        = 'jenkins'
  $_java_args   = '-Djava.awt.headless=true -Djenkins.install.runSetupWizard=false'
  $default_plugins = [
    'credentials', # required by puppet_helper.groovy
  ]
  $purge_plugins = false

  case $::osfamily {
    'Debian': {
      $libdir           = '/usr/share/jenkins'
      $package_provider = 'dpkg'
      $service_provider = undef
      $sysconfdir       = '/etc/default'
      $config_hash_defaults = {
        'JAVA_ARGS' => { value => $_java_args },
        'AJP_PORT'  => { value => '-1' },
      }
    }
    'FreeBSD': {
      $libdir           = '/usr/local/share/jenkins'
      $package_provider = 'pkgng'
      $service_provider = undef
      $sysconfdir       = '/usr/local/etc/default'
      $config_hash_defaults = {
        'JAVA_ARGS' => { value => $_java_args },
        'AJP_PORT'  => { value => '-1' },
      }
    }
    'RedHat': {
      $libdir           = '/usr/lib/jenkins'
      $package_provider = 'rpm'
      $sysconfdir           = '/etc/sysconfig'
      $config_hash_defaults = {
        'JENKINS_JAVA_OPTIONS' => { value => $_java_args },
        'JENKINS_AJP_PORT'     => { value => '-1' },
      }

      # explicitly use systemd if it is available
      # XXX only enable explicit systemd support on RedHat at this time due to
      # the Debian packaging using variable interpolation in
      # /etc/default/jenkins.
      # XXX this param exists because of a historical work around to PUP-5353
      # it is part of the public interface to ::jenkins; it needs to be
      # maintained until at least a major version bump.  It has been somewhat
      # repurposed as a flag for specific systemd support.
      if $::systemd {
        $service_provider = 'systemd'
      } else {
        $service_provider = undef
      }
    }
    default: {
      $libdir               = '/usr/lib/jenkins'
      $package_provider     = undef
      $service_provider     = undef
      $sysconfdir           = '/etc/sysconfig'
      $config_hash_defaults = {
        'JENKINS_JAVA_OPTIONS' => { value => $_java_args },
        'JENKINS_AJP_PORT'     => { value => '-1' },
      }
    }
  }
}
