require 'spec_helper'
describe 'loginconf' do
  context 'with default values for all parameters' do
    it { should contain_class('loginconf') }
  end
end
