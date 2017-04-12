# The baseline for module testing used by Puppet Labs is that each manifest
# should have a corresponding test manifest that declares that class or defined
# type.
#
# Tests are then run by using puppet apply --noop (to check for compilation
# errors and view a log of events) or by fully applying the test in a virtual
# environment (to compare the resulting system state to the desired state).
#
# Learn more about module testing here:
# https://docs.puppet.com/guides/tests_smoke.html
#
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
