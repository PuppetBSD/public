require 'spec_helper'

describe 'swift::proxy::staticweb' do

  let :facts do
    {}
  end

  it { is_expected.to contain_concat_fragment('swift-proxy-staticweb').with_content(/[filter:staticweb]/) }
  it { is_expected.to contain_concat_fragment('swift-proxy-staticweb').with_content(/use = egg:swift#staticweb/) }

end
