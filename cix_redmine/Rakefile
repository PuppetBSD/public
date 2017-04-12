require 'rubygems'
require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-lint/tasks/puppet-lint'
require 'rake/clean'


# These two gems aren't always present, for instance
# on Travis with --without development
begin
  require 'puppet_blacksmith/rake_tasks'
rescue LoadError
end

clean_paths = ["spec/fixtures/*", "pkg"]
CLEAN.include(clean_paths)

desc "Run acceptance tests"
RSpec::Core::RakeTask.new(:acceptance) do |t|
  t.pattern = 'spec/acceptance'
end

exclude_paths = ["spec/**/*.pp", "pkg/**/*.pp", "vendor/**/*.pp"]
Rake::Task[:lint].clear
PuppetLint::RakeTask.new :lint do |config|
  config.disable_checks = [
    '80chars',
    'class_parameter_defaults',
    'class_inherits_from_params_class',
  ]
  config.log_format = "%{path}:%{linenumber}:%{check}:%{KIND}:%{message}"
  config.fail_on_warnings = true
  PuppetLint.configuration.relative = true # workaround until puppet-lint 1.1.1 is released

  config.ignore_paths = exclude_paths
end

desc "Run syntax, lint, and spec tests."
task :test => [
  :validate,
  :lint,
  :spec,
]

desc "Validate manifests, templates, and ruby files"
task :validate do
  Dir['manifests/**/*.pp'].each do |manifest|
    sh "puppet parser validate --noop #{manifest}"
  end
  Dir['spec/**/*.rb','lib/**/*.rb'].each do |ruby_file|
    sh "ruby -c #{ruby_file}" unless ruby_file =~ /spec\/fixtures/
  end
  Dir['templates/**/*.erb'].each do |template|
    sh "erb -P -x -T '-' #{template} | ruby -c"
  end
end
