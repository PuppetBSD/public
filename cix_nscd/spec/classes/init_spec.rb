require 'spec_helper'
describe 'ldapize' do

  context 'with default values for all parameters' do
    it { should contain_class('ldapize') }
  end
end
