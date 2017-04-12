# ttys

#### Table of Contents

1. [Description](#description)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Description

Manage /etc/ttys file content on FreeBSD platform

## Usage

~~
 class { "ttys":
   ttyv => [
     { name => 'console',    getty => 'none',                                type => 'unknown',      status => 'off',                comments => 'secure' },
     { name => 'ttyv0',      getty => '"/usr/libexec/getty Pc"',             type => 'xterm',        status => 'on',                 comments => 'secure' },
     { name => 'ttyv1',      getty => '"/usr/libexec/getty Pc"',             type => 'xterm',        status => 'on',                 comments => 'secure' },
     { name => 'ttyv2',      getty => '"/usr/libexec/getty Pc"',             type => 'xterm',        status => 'on',                 comments => 'secure' },
     { name => 'ttyu0',      getty => '"/usr/libexec/getty 3wire"',          type => 'vt100',        status => 'onifconsole',        comments => 'secure' },
     { name => 'ttyu1',      getty => '"/usr/libexec/getty 3wire"',          type => 'vt100',        status => 'onifconsole',        comments => 'secure' },
     { name => 'dcons',      getty => '"/usr/libexec/getty std.9600"',       type => 'vt100',        status => 'off',                comments => 'secure' },
   ],
 }
~~~

## Limitations

- FreeBSD OS

## Development

Fill free to send pull request
