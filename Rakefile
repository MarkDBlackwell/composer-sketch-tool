require 'rake/clean'

# Print a stack trace if we hit an error in the code that rake calls.
Rake.application.options.trace = true

task :default => [:test]

desc 'Run all the tests'
task :test do
  require 'rake/runtest'
  Rake.run_tests 'test*.rb'
  puts 'Ran tests'
end

desc 'Build the duodecimal notespace'
task :build do
  sh "ruby -e \"require 'build'; Invoke::Build.new( note_space_width = 12)\""
#  build.rb > build-out.txt'
  puts 'Built the duodecimal notespace'
end

desc 'List the duodecimal notespace'
task :list do
  sh "ruby -e \"require 'list'; Invoke::List.new( note_space_width = 12).run()\""
#  sh 'ruby list.rb > list-out.txt'
  puts 'Listed the duodecimal notespace'
end

desc 'Dump the duodecimal notespace'
task :dump do
  sh "ruby -e \"require 'dump'; Invoke::Dump.new( note_space_width = 12).run()\""
#  sh 'ruby dump.rb > dump-out.txt'
  puts 'Dumped the duodecimal notespace'
end

desc 'Play the duodecimal notespace'
task :play do
  sh "ruby -e \"require 'play'; Invoke::Play.new( note_space_width = 12).run()\""
#  sh 'ruby play.rb > play-out.txt'
  puts 'Played the duodecimal notespace'
end
