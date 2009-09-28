  require 'rake/clean'
# Print a stack trace if you get an error in the code that rake calls.
  Rake.application.options.trace = true

  task :default => [:test]

  desc 'Generate consonant chords for the duodecimal notespace'
  task :duodecimal_consonants do
    puts 'Generated duodecimal consonant chords'
  end

  desc 'Run the program'
  task :run do
    sh 'ruby run.rb > thirdsout.txt'
    puts 'Ran program'
  end

  desc 'Test the program'
  task :test do
    require 'rake/runtest'
    Rake.run_tests 'test*.rb'
    puts 'Ran tests'
  end

