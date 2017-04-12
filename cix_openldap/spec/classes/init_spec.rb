require 'spec_helper'
describe 'cixopenldap' do
  context 'with default values for all parameters' do
    it { should contain_class('cixopenldap') }
  end
end
