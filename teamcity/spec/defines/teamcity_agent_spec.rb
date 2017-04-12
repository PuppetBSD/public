require 'spec_helper'

describe 'teamcity::agent', :type => 'define' do

  context "On Ubuntu 15.04" do
    let(:facts) {{
        :osfamily         => 'Debian',
        :operatingsystem  => 'Debian',
        :lsbdistcodename  => 'vivid',
    }}

    let(:title) {"one"}

    let(:params){{
      :master_url => 'http://localhost:90',
    }}

    it {
      should contain_user('teamcity')
      should contain_group('teamcity')
      should contain_file('/opt/teamcity-sources')
      should contain_file('/opt/teamcity_agent_one/bin/agent.sh')
      should contain_file('/etc/systemd/system/teamcity-agent-one.service')
      should contain_archive('teamcity-agent-one').with({
        'url'     => 'http://localhost:90/update/buildAgent.zip',
        'target'  => '/opt/teamcity_agent_one',
      })
      should contain_service('teamcity-agent-one')
    }
  end


  context "On Ubuntu 15.04 with no master url set" do
    let(:facts) {{
        :osfamily         => 'Debian',
        :operatingsystem  => 'Debian',
        :lsbdistcodename  => 'vivid',
    }}

    let(:title) {"one"}

    it do
      expect {
        should compile
      }.to raise_error(/.*Please set \$master_url.*/)
    end
  end


  context "On Ubuntu 15.04 with central master url set" do
    let(:facts) {{
        :osfamily         => 'Debian',
        :operatingsystem  => 'Debian',
        :lsbdistcodename  => 'vivid',
    }}

    let(:pre_condition) {'
      class { teamcity::params:
        agent_master_url => "http://localhost:90",
      }
  '}

    let(:title) {"one"}

    it {
      should contain_archive('teamcity-agent-one').with({
        'url' => 'http://localhost:90/update/buildAgent.zip',
      })
    }
  end

end
