# loginconf

#### Table of Contents

1. [Description](#description)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Description

Configure /etc/login.conf content on FreeBSD

## Usage

~~~
class { 'loginconf':
        charset => "UTF-8",
        lang => "en_US.UTF-8",
}
~~~

## Limitations

This work on FreeBSD platform only.
Some of the part still not puppetize, since these parameters are not used by me (not tested)

## Development

Fill free to send pull request
