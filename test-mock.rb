require 'test/unit'
require 'build'
#load File.dirname(__FILE__) + '/example-program.rb'

# A file for tests involving mocking out (monkeypatching) program classes.
module Invoke # Mock out some methods of some of the program's classes.
#-----------------------------
  class MyFile
    class << self
      attr_accessor :file_name, :method, :contents
    end
    def self.open( f, m) # Mock out a class method.
      @file_name = f
      @method = m
      yield self.new()
    end
    def write( c)
      self.class.contents = c # Set the class's '@' variable.
    end
  end #class MyFile
#-----------------------------
  class MyLogger
    class << self
      attr_accessor :file_name, :message
    end
    def initialize( f)
      self.class.file_name = f
    end
    def debug( m)
      self.class.message = m
    end
  end #class MyLogger
#-----------------------------
  class TestBuildSave < Test::Unit::TestCase
    def test_save_file_name
      SomeClass.new( 1).save() # Assume this uses MyFile to write.
      assert_equal( 'some-class-1.txt', MyFile.file_name)
      assert_equal( 'w', MyFile.method)
    end
    def test_save_contents
      SomeClass.new( 2).save()
      assert_equal( 'contents-2', MyFile.contents)
    end
  end #class TestBuildSave
#-----------------------------
  class TestLoggerBuild < Test::Unit::TestCase
    def setup
      Build.new( 0) # Assume this uses MyLogger to log.
    end
    def test_log_file_name
      assert_equal( MyLogger.file_name, 'log/build.txt')
    end
    def test_log_message
      assert( true, MyLogger.message.include?( 'in Invoke::Build#initialize'))
    end
  end #class TestLoggerBuild
end #module Invoke
