require 'spec_helper'

describe 'teamcity::master', :type => 'class' do

  context "Ubuntu 15.04 without database" do
    let(:facts) {{
        :osfamily         => 'Debian',
        :operatingsystem  => 'Debian',
        :lsbdistcodename  => 'vivid',
    }}

    it {
      should contain_service('teamcity')
      should contain_archive('teamcity-9.1.3')

      should contain_user('teamcity')
      should contain_group('teamcity')
      should contain_file('/opt/teamcity-sources')

      should_not contain_class('teamcity::db::install')
      should_not contain_class('teamcity::db::config')
      should_not contain_file('/var/lib/teamcity/config/database.properties')
    }
  end


  context "Ubuntu 15.04 WITH database (postgres)" do
    let(:facts) {{
        :osfamily         => 'Debian',
        :operatingsystem  => 'Debian',
        :lsbdistcodename  => 'vivid',
    }}

    let(:pre_condition) {'
      class { teamcity::params:
        db_type           => postgresql,
        db_host           => localhost,
        db_name           => teamcity,
        db_user           => teamcity,
        db_pass           => teamcity,
        db_port           => 5432,
        jdbc_download_url => "http://localhost/myfile.jar",
      }
  '}

    it {
      should contain_archive('teamcity-9.1.3')
      should contain_class('teamcity::db::install')
      should contain_class('teamcity::db::config')
      should contain_file('/var/lib/teamcity/config/database.properties')
      should contain_wget__fetch('http://localhost/myfile.jar').with({
        'destination' => '/var/lib/teamcity/lib/jdbc/myfile.jar',
        'user'        => 'teamcity',
      })
    }
  end

end
