require 'spec_helper'

describe 'lam', :type => :module do

  shared_examples 'a Linux OS' do
    it { should compile.with_all_deps }
    it { should contain_class('lam') }
    it { should contain_class('lam::params') }
    it { should contain_class('lam::package') }
    it { should contain_class('lam::config') }
    it { should contain_anchor('lam::begin').that_comes_before('Class[lam::package]') }
    it { should contain_anchor('lam::end').that_requires('Class[lam::config]') }
  end

  context 'On a Debian OS with valid params' do
    let :params do
      {
        :ldap_suffix => 'dc=example,dc=com',
        :ldap_host => 'localhost',
        :ldap_bind_id => 'username',
        :ldap_bind_pass => 'password',
      }
    end
    it_behaves_like 'a Linux OS' do
      let :facts do
        {
          :operatingsystem => 'Debian',
          :osfamily => 'Debian',
        }
      end
    end
  end

  context 'On a CentOS OS with valid params' do
    let :params do
      {
        :ldap_suffix => 'dc=example,dc=com',
        :ldap_host => 'localhost',
        :ldap_bind_id => 'username',
        :ldap_bind_pass => 'password',
      }
    end
    it_behaves_like 'a Linux OS' do
      let :facts do
        {
          :operatingsystem => 'CentOS',
          :osfamily => 'RedHat',
        }
      end
    end
  end

  context 'On a Debian OS with invalid params' do
    let :params do
      {
        :ldap_host => 'localhost',
        :ldap_bind_id => 'username',
        :ldap_bind_pass => 'password',
      }
    end
    let :facts do
      {
        :operatingsystem => 'Debian',
        :osfamily => 'Debian',
      }
    end
    it 'should fail if params not valid' do
      expect { should raise_error(/Invalid param/) }
    end
  end
    
  context 'On other OS' do
    let :facts do
      {
        :operatingsystem => 'xxx',
        :osfamily => 'xxx',
      }
    end
    it 'should fail if OS not supported' do
      expect { should compile }.to raise_error(/Unsupported OS family/)
    end
  end
end
