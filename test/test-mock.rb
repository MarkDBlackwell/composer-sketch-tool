require 'test/unit'
require 'build'
# A file for tests involving mocking out (monkeypatching) program classes.
module Invoke
#-----------------------------
# Mock out some methods of some of the program's classes.
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

    def print( c)
      self.class.contents = c # Set the class's '@' variable.
    end #def
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
    end #def
  end #class MyLogger
#-----------------------------
# Define program test classes which use the mocked classes above.
#-----------------------------
  class TestBuildChordsSave < Test::Unit::TestCase
    def setup
      Build.new( 0).save_chords() # Assume this uses MyFile to write.
    end

    def test_file_name
      assert_equal( 'marshal/chords-0.txt', MyFile.file_name)
      assert_equal( 'w', MyFile.method)
    end

    def test_contents
      assert_equal( 'contents-0', MyFile.contents)
    end #def
  end #class TestBuildChordsSave
#-----------------------------
  class TestBuildNecklacesSave < Test::Unit::TestCase
    def setup
      Build.new( 0).save_necklaces() # Assume this uses MyFile to write.
    end

    def test_file_name
      assert_equal( 'marshal/necklaces-0.txt', MyFile.file_name)
      assert_equal( 'w', MyFile.method)
    end

    def test_contents
      assert_equal( 'contents-0', MyFile.contents)
    end #def
  end #class TestBuildNecklacesSave
#-----------------------------
  class TestBuildLogger < Test::Unit::TestCase
    def setup
      @file_name = 'log/build.txt'
      File.open( @file_name, 'r') {|f| @lines = f.readlines}
      Build.new( 0) # Assume this uses MyLogger to log.
    end

    def test_file_name
      assert_equal( @file_name, MyLogger.file_name)
    end

    def test_message
      assert( true, MyLogger.message.include?( 'in Invoke::Build#initialize'))
    end #def
  end #class TestLoggerBuild
end #module Invoke
