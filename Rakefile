require 'rake/clean'
require 'spec/rake/spectask' # Enable Rake to run Rspec.
require 'load_path_fix'
#----------------------
# Print a stack trace if we hit an error in the code that rake calls.
Rake.application.options.trace = true

task :default => [:spec]

desc 'Run all the Rspec tests' # For Rspec version 1.2.9.
# See http://rspec.info/documentation/tools/rake.html
Spec::Rake::SpecTask.new( :spec) do |t|
  t.fail_on_error = false
  t.pattern = 'test/*_spec.rb'
  t.rcov = false
#  t.ruby_opts = [ '-w'] # Not use '-w', because it: [1] already is set for tests; [2] produces warnings in Rspec code.
  t.spec_opts = [ '--require load_path_fix', '--color', '--format nested']
  t.verbose = false
  t.warning = false # Not use 'true', because it produces warnings in Rspec code.
end

desc 'Run all the separate test/unit tests'
task :separate_test_unit do
  require 'rake/runtest'
  Rake.run_tests FileList.new( 'test/test*.rb')
end

desc 'Build the duodecimal notespace'
task :build do
  sh "ruby -e \"require 'build'; Invoke::Build.new( note_space_width = 12)\""
#  build.rb > build-out.txt'
end

desc 'List the duodecimal notespace'
task :list do
  sh "ruby -e \"require 'list'; Invoke::List.new( note_space_width = 12).run()\""
#  sh 'ruby list.rb > list-out.txt'
end

desc 'Dump the duodecimal notespace'
task :dump do
  sh "ruby -e \"require 'dump'; Invoke::Dump.new( note_space_width = 12).run()\""
#  sh 'ruby dump.rb > dump-out.txt'
end

desc 'Play the duodecimal notespace'
task :play do
  sh "ruby -e \"require 'play'; Invoke::Play.new( note_space_width = 12).run()\""
#  sh 'ruby play.rb > play-out.txt'
end
