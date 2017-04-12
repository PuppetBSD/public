notification :off

guard 'rake', :task => 'test' do
  watch(%r{^manifests/.+\.pp$})
  watch(%r{^spec/(classes|defines|functions|hosts)/.+_spec\.rb$})
end
