# -*- mode: ruby -*-
# vi: set ft=ruby :
#
require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-lint/tasks/puppet-lint'
require 'puppet-syntax/tasks/puppet-syntax'

NAME = 'markhellewell-aptcacherng'
TDIR = File.expand_path(File.dirname(__FILE__))

exclude_tests_paths = ['pkg/**/*','vendor/**/*','spec/**/*']
PuppetLint.configuration.ignore_paths = exclude_tests_paths
PuppetLint.configuration.fail_on_warnings = true
PuppetSyntax.exclude_paths = exclude_tests_paths

namespace :module do
  desc "Build #{NAME} module (in a clean env) Please use this for puppetforge"
  task :build do
    exec "rsync -rv --exclude-from=#{TDIR}/.forgeignore . /tmp/#{NAME};cd /tmp/#{NAME};puppet module build"
  end
end

desc 'Run syntax, lint and spec tests'
task :test => [:syntax,:lint,:spec]
