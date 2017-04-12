# puppet-teamcity

A module which installs JetBrains' TeamCity or agent on a server.

The Teamcity installation id done by downloading the files from JetBrains. The agent installation is done by downloading the files directly from the working TeamCity server, so the agent installation will fail as long as the server is not running (precisely: the buildAgent.zip file cannotm be downloaded from the TC server).

It is possible to install multiple agents on one server. Each agent will become its own service and installation directory. It is also possible to just use the agent installation, in case the TeamCity master is installed by other means (docker, for example) and not under the control of this puppet module.


## Limitations

Currently only the postgres database can be fully configured. It should be possible though to "install" TeamCity without database configuration, and do it manually afterwards.


## Dependencies

The module will install java (using `include java` and the `puppetlabs/java` module), then download and install teamcity including the postgres JDBC jar. It will also create a systemd service file.


## Tested on

- ubuntu 15.10

... but should work on any systemd-based distribution, including RedHat, arch and Debian. I greatly appreciate feedback!


## Usage

    include teamcity::master

Automate database configuration:

    class { 'teamcity::params':
        db_type => 'postgresql',
        db_host => 'localhost',
        db_name => 'teamcity',
        db_user => 'teamcity',
        db_pass => 'shabalahaalalahaha',
    }

    include teamcity::master

Download TeamCity from a locally hosted location:

    class { 'teamcity::params':
        teamcity_base_url => 'http://machine.company.com/artifacts/teamcity-903.tgz',
    }

    include teamcity::master

Add one (or more) agents on the local machine (note that the agent installation will fail until the master is up and running!):

    include teamcity::master
    teamcity::agent { 'myagent':
        agent_master_url => 'http://teamcity-master:8111'
    }
    teamcity::agent { 'myotheragent':
        agent_master_url => 'http://teamcity-master:8111'
    }

    # or alternatively, using a central definition with the params class,
    # and don't install teamcity on the same host:

    class { 'teamcity::params':
        agent_master_url => 'http://teamcity-master:8111',
    }
    teamcity::agent { 'myagentone': }
    teamcity::agent { 'myagenttwo': }

Also note that the agent names (`myagent`, `myotheragent`, ...) must be unique across all agents. So you could do something like `"${ipaddress_eth0}.agent0"`, for example.

Most of the parameters should be pretty self-explanatory, if not you probably should not use them for now.


## NEWS

### v0.5.0, 2016-06-27

- added LDAP configuration support
- made archive provider configurable (puppet/archive, camptocamp/archive)

