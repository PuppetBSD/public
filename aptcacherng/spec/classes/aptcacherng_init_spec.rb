require 'spec_helper'

# aptcacherng
describe 'aptcacherng', :type => :class do

  describe 'On an unknown osfamily' do
    let(:facts) {{ :osfamily => 'Fooboozoo' }}
    it 'should fail' do
      expect do
        subject
      end.to raise_error(Puppet::Error, /aptcacherng: Fooboozoo not supported./)
    end
  end

  describe 'On Debian' do
    let(:facts) {{ :osfamily => 'Debian' }}

    it { should contain_class('aptcacherng::params') }
    it { should contain_package('apt-cacher-ng') }
    it { should contain_service('apt-cacher-ng') }

    it { should contain_file('/etc/apt-cacher-ng/zz_debconf.conf').with_ensure('absent')}

    describe 'With default params' do
      ['/var/cache/apt-cacher-ng','/var/log/apt-cacher-ng'].each do |d|
        it { should contain_file(d).with(
          :ensure  => 'directory',
          :owner   => 'apt-cacher-ng',
          :group   => 'apt-cacher-ng',
          :mode    => '2755',
          :require => 'Package[apt-cacher-ng]',
          :before  => 'Service[apt-cacher-ng]'
        )}
      end

      it { should contain_file('/etc/apt-cacher-ng/acng.conf').with(
        :owner   => 'root',
        :group   => 'root',
        :mode    => '0644',
        :require => 'Package[apt-cacher-ng]'
      )}

      it { should contain_file('/etc/apt-cacher-ng/acng.conf').with_content(/^CacheDir: \/var\/cache\/apt-cacher-ng$/) }
      it { should contain_file('/etc/apt-cacher-ng/acng.conf').with_content(/^LogDir: \/var\/log\/apt-cacher-ng$/) }
      it { should contain_file('/etc/apt-cacher-ng/acng.conf').with_content(/^Port: 3142$/) }
      it { should contain_file('/etc/apt-cacher-ng/acng.conf').with_content(/^ReportPage: acng-report.html$/) }
      it { should contain_file('/etc/apt-cacher-ng/acng.conf').with_content(/^ExTreshold: 4$/) }

      it { should_not contain_file('/etc/apt-cacher-ng/security.conf') }

    end # with default params

    describe 'With specific params' do

      ## Parameter set
      # a non-default common parameter set
      let :params_set do
        {
          :cachedir             => '/srv/apt-cacher-ng/cache',
          :logdir               => '/srv/apt-cacher-ng/logs',
          :supportdir           => '/srv/apt-cacher-ng/files',
          :port                 => '6666',
          :bindaddress          => 'apt-cacher.mydomain.tld 0.0.0.0',
          :proxy                => 'username:proxypassword@proxy.example.net:3128',
          :remap_lines          => 'Remap-debrep: file:deb_mirror',
          :reportpage           => 'report.html',
          :socketpath           => '/srv/apt-cacher-ng/socket',
          :unbufferlogs         => '1',
          :verboselog           => '1',
          :foreground           => '1',
          :pidfile              => '/srv/apt-cacher-ng/pid',
          :offlinemode          => '0',
          :forcemanaged         => '1',
          :extreshold           => '4',
          :exabortonproblems    => '30',
          :stupidfs             => '1',
          :forwardbtssoap       => '0',
          :dnscacheseconds      => '7200',
          :maxstandbyconthreads => '16',
          :maxconthreads        => '-1',
          :vfilepattern         => 'foo',
          :pfilepattern         => 'boo',
          :wfilepattern         => 'zoo',
          :passthroughpattern   => 'baz',
          :debug                => '3',
          :exposeorigin         => '1',
          :logsubmittedorigin   => '1',
          :useragent            => 'Yet Another HTTP Client',
          :recompbz2            => '1',
          :networktimeout       => '120',
          :dontcacherequested   => 'linux-headers-i386',
          :dontcacheresolved    => 'ubuntumirror.local.net',
          :dontcache            => 'linux-headers-i386',
          :dirperms             => '00755',
          :fileperms            => '00644',
          :localdirs            => 'woo hamm',
          :precachefor          => 'debrep',
          :requestappendix      => 'X-Tracking-Choice: do-not-track',
          :connectproto         => 'v6 v4',
          :keepextraversions    => '1',
          :usewrap              => '1',
          :freshindexmaxage     => '42',
          :allowuserports       => '8080',
          :redirmax             => '10',
          :vfileuserangeops     => '0',
          :auth_username        => 'blah',
          :auth_password        => 'ChangeMe'
        }
      end

      let(:params) { params_set }

      it { should contain_file('/etc/apt-cacher-ng/acng.conf').with_content(/^CacheDir: #{params_set[:cachedir]}$/)}
      it { should contain_file('/etc/apt-cacher-ng/acng.conf').with_content(/^LogDir: #{params_set[:logdir]}$/)}
      it { should contain_file('/etc/apt-cacher-ng/acng.conf').with_content(/^SupportDir: #{params_set[:supportdir]}$/)}
      it { should contain_file('/etc/apt-cacher-ng/acng.conf').with_content(/^Port: #{params_set[:port]}$/)}
      it { should contain_file('/etc/apt-cacher-ng/acng.conf').with_content(/^BindAddress: #{params_set[:bindaddress]}$/)}
      it { should contain_file('/etc/apt-cacher-ng/acng.conf').with_content(/^Proxy: #{params_set[:proxy]}$/)}
      it { should contain_file('/etc/apt-cacher-ng/acng.conf').with_content(/^#{params_set[:remap_lines]}$/)}
      it { should contain_file('/etc/apt-cacher-ng/acng.conf').with_content(/^ReportPage: #{params_set[:reportpage]}$/)}
      it { should contain_file('/etc/apt-cacher-ng/acng.conf').with_content(/^SocketPath: #{params_set[:socketpath]}$/)}
      it { should contain_file('/etc/apt-cacher-ng/acng.conf').with_content(/^UnbufferLogs: #{params_set[:unbufferlogs]}$/)}
      it { should contain_file('/etc/apt-cacher-ng/acng.conf').with_content(/^VerboseLog: #{params_set[:verboselog]}$/)}
      it { should contain_file('/etc/apt-cacher-ng/acng.conf').with_content(/^ForeGround: #{params_set[:foreground]}$/)}
      it { should contain_file('/etc/apt-cacher-ng/acng.conf').with_content(/^PidFile: #{params_set[:pidfile]}$/)}
      it { should contain_file('/etc/apt-cacher-ng/acng.conf').with_content(/^OfflineMode: #{params_set[:offlinemode]}$/)}
      it { should contain_file('/etc/apt-cacher-ng/acng.conf').with_content(/^ForceManaged: #{params_set[:forcemanaged]}$/)}
      it { should contain_file('/etc/apt-cacher-ng/acng.conf').with_content(/^ExTreshold: #{params_set[:extreshold]}$/)}
      it { should contain_file('/etc/apt-cacher-ng/acng.conf').with_content(/^ExAbortOnProblems: #{params_set[:exabortonproblems]}$/)}
      it { should contain_file('/etc/apt-cacher-ng/acng.conf').with_content(/^StupidFs: #{params_set[:stupidfs]}$/)}
      it { should contain_file('/etc/apt-cacher-ng/acng.conf').with_content(/^ForwardBtsSoap: #{params_set[:forwardbtssoap]}$/)}
      it { should contain_file('/etc/apt-cacher-ng/acng.conf').with_content(/^DnsCacheSeconds: #{params_set[:dnscacheseconds]}$/)}
      it { should contain_file('/etc/apt-cacher-ng/acng.conf').with_content(/^MaxStandbyConThreads: #{params_set[:maxstandbyconthreads]}$/)}
      it { should contain_file('/etc/apt-cacher-ng/acng.conf').with_content(/^MaxConThreads: #{params_set[:maxconthreads]}$/)}
      it { should contain_file('/etc/apt-cacher-ng/acng.conf').with_content(/^VfilePattern: #{params_set[:vfilepattern]}$/)}
      it { should contain_file('/etc/apt-cacher-ng/acng.conf').with_content(/^PfilePattern: #{params_set[:pfilepattern]}$/)}
      it { should contain_file('/etc/apt-cacher-ng/acng.conf').with_content(/^WfilePattern: #{params_set[:wfilepattern]}$/)}
      it { should contain_file('/etc/apt-cacher-ng/acng.conf').with_content(/^PassThroughPattern: #{params_set[:passthroughpattern]}$/)}
      it { should contain_file('/etc/apt-cacher-ng/acng.conf').with_content(/^Debug: #{params_set[:debug]}$/)}
      it { should contain_file('/etc/apt-cacher-ng/acng.conf').with_content(/^ExposeOrigin: #{params_set[:exposeorigin]}$/)}
      it { should contain_file('/etc/apt-cacher-ng/acng.conf').with_content(/^LogSubmittedOrigin: #{params_set[:logsubmittedorigin]}$/)}
      it { should contain_file('/etc/apt-cacher-ng/acng.conf').with_content(/^UserAgent: #{params_set[:useragent]}$/)}
      it { should contain_file('/etc/apt-cacher-ng/acng.conf').with_content(/^RecompBz2: #{params_set[:recompbz2]}$/)}
      it { should contain_file('/etc/apt-cacher-ng/acng.conf').with_content(/^NetworkTimeout: #{params_set[:networktimeout]}$/)}
      it { should contain_file('/etc/apt-cacher-ng/acng.conf').with_content(/^DontCacheRequested: #{params_set[:dontcacherequested]}$/)}
      it { should contain_file('/etc/apt-cacher-ng/acng.conf').with_content(/^DontCacheResolved: #{params_set[:dontcacheresolved]}$/)}
      it { should contain_file('/etc/apt-cacher-ng/acng.conf').with_content(/^DontCache: #{params_set[:dontcache]}$/)}
      it { should contain_file('/etc/apt-cacher-ng/acng.conf').with_content(/^DirPerms: #{params_set[:dirperms]}$/)}
      it { should contain_file('/etc/apt-cacher-ng/acng.conf').with_content(/^FilePerms: #{params_set[:fileperms]}$/)}
      it { should contain_file('/etc/apt-cacher-ng/acng.conf').with_content(/^LocalDirs: #{params_set[:localdirs]}$/)}
      it { should contain_file('/etc/apt-cacher-ng/acng.conf').with_content(/^PrecacheFor: #{params_set[:precachefor]}$/)}
      it { should contain_file('/etc/apt-cacher-ng/acng.conf').with_content(/^RequestAppendix: #{params_set[:requestappendix]}$/)}
      it { should contain_file('/etc/apt-cacher-ng/acng.conf').with_content(/^ConnectProto: #{params_set[:connectproto]}$/)}
      it { should contain_file('/etc/apt-cacher-ng/acng.conf').with_content(/^KeepExtraVersions: #{params_set[:keepextraversions]}$/)}
      it { should contain_file('/etc/apt-cacher-ng/acng.conf').with_content(/^UseWrap: #{params_set[:usewrap]}$/)}
      it { should contain_file('/etc/apt-cacher-ng/acng.conf').with_content(/^FreshIndexMaxAge: #{params_set[:freshindexmaxage]}$/)}
      it { should contain_file('/etc/apt-cacher-ng/acng.conf').with_content(/^AllowUserPorts: #{params_set[:allowuserports]}$/)}
      it { should contain_file('/etc/apt-cacher-ng/acng.conf').with_content(/^RedirMax: #{params_set[:redirmax]}$/)}
      it { should contain_file('/etc/apt-cacher-ng/acng.conf').with_content(/^VfileUseRangeOps: #{params_set[:vfileuserangeops]}$/)}

      it { should contain_file('/etc/apt-cacher-ng/security.conf').with_content(/^AdminAuth: #{params_set[:auth_username]}:#{params_set[:auth_password]}$/)}

    end

  end # Debian

end # aptcacherng
