require 'spec_helper'
describe 'ttys' do
  context 'with default values for all parameters' do
    it { should contain_class('ttys') }
  end
end
