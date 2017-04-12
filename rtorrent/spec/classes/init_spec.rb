require 'spec_helper'
describe 'rtorrent' do

  context 'with default values for all parameters' do
    it { should contain_class('rtorrent') }
  end
end
