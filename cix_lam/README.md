# lam

[![Build Status](https://travis-ci.org/Spantree/puppet-lam.svg?branch=master)](https://travis-ci.org/Spantree/puppet-lam)

Sebastian Otaegui <feniix@gmail.com>

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with lam](#setup)
    * [What lam affects](#what-lam-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with lam](#beginning-with-lam)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

The lam module installs and configures lam.

## Module Description

This module installs lam, and sets up the file '/etc/lam/config.php' with provided user/password and hostname.

## Setup

### What lam affects

* Install the `lam` package.
* Modify the file `/etc/lam/config.php` with custom values.

### Beginning with lam

`puppet module install spantree-lam` and follow the instructions specified on the Usage section.

## Usage

```puppet
class { 'lam':
  ldap_host      => 'localhost',
  ldap_suffix    => 'dc=domain,dc=tld',
  ldap_bind_id   => 'cn=admin,dc=domain,dc=tld',
  ldap_bind_pass => 'password',
  extraconf      => "
      \$servers->newServer('ldap_pla');
      \$servers->SetValue('server','name','LDAP MyDomain (slave)');
      \$servers->SetValue('server','host','ldap2.mydomain.org');
      \$servers->SetValue('server','port','389');
      \$servers->SetValue('server','base',array('dc=mydomain,dc=org','cn=config'));
      \$servers->SetValue('login','auth_type','session');
      \$servers->SetValue('login','bind_id','cn=admin,dc=mydomain,dc=org');
      \$servers->SetValue('server','tls',false);
      \$servers->SetValue('appearance','password_hash','crypt');
      \$servers->SetValue('server','read_only',false);
      \$servers->SetValue('appearance','show_create',true);
      \$servers->SetValue('auto_number','enable',false);"
}
```
or in hiera
```yaml
---
lam::extraconf : |
  $servers->newServer('ldap_pla');
  $servers->SetValue('server','name','LDAP MyDomain (slave)');
  $servers->SetValue('server','host','ldap2.mydomain.org');
  $servers->SetValue('server','port','389');
  $servers->SetValue('server','base',array('dc=mydomain,dc=org','cn=config'));
  $servers->SetValue('login','auth_type','session');
  $servers->SetValue('login','bind_id','cn=admin,dc=mydomain,dc=org');
  $servers->SetValue('server','tls',false);
  $servers->SetValue('appearance','password_hash','crypt');
  $servers->SetValue('server','read_only',false);
  $servers->SetValue('appearance','show_create',true);
  $servers->SetValue('auto_number','enable',false);
```

To use the module with CentOS you need to add the `EPEL` repository, one way to do that is to use the module `stahnma/epel`.

## Reference

#### Public classes

* [**lam**](#class-lam)

#### Private classes

* **lam::config**: writes the file `/etc/lam/config.php` with proper values.

* **lam::package**: installs the package using the package manager.

###Class: lam

This class is provided to do the basic setup tasks required for using lam.

At the moment if does not take care of setting up a web server to serve the web pages.

####`ldap_host`

Parameter that controls the ldap the lam needs to connect.

`ldap_host` can either be an ipv4 address or a hostname.

####`ldap_suffix`

Parameter that controls the top level suffix for the ldap.

`ldap_suffix` must be a string with the appropriate suffix.

####`ldap_bind_id`

Parameter that controls the id used to bind and manage the ldap.

`ldap_bind_id` must be a user that has administrative access to the ldap server.

####`ldap_bind_pass`

Optional parameter that controls the password of the user specified in the `ldap_bind_id` parameter.

If not specified, you wil be prompted for the password.

## Limitations

This module has been tested on Ubuntu 14.04 and CentOS 6.5. It should also work on Debian/Ubuntu 12.04 and RedHat/CentOS 7.

At the moment it does not configure the lam app with SASL.

## Development

Use your favorite text editor (mine is vim) and run `bundle exec rake test` to test, don't forget to `bundle install` first.

## Release Notes/Contributors/Etc

To do
