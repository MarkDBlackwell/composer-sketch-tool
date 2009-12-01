require 'rake/clean'

# Print a stack trace if we hit an error in the code that rake calls.
Rake.application.options.trace = true

task :default => [:test]

desc 'Run all the tests'
task :test do
  sh "ruby test/test-mock.rb" # Unload mocked classes before other tests.
  require 'rake/runtest'
  Rake.run_tests FileList.new( 'test/test*.rb').exclude( 'test/test-mock.rb')
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
