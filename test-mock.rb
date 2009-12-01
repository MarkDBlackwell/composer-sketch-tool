require 'test/unit'
require 'build'
# A file for tests involving mocking out (monkeypatching) program classes.
module Invoke # Mock out some methods of some of the program's classes.
#-----------------------------
  class MyFile
    class << self
      attr_accessor :file_name, :method, :contents
    end
    def initialize( f, m)
      self.class.file_name = f
      self.class.method = m
    end
    def self.open( file_name, method) # Mock out a class method.
      file = self.new( file_name, method)
      return file unless block_given?
    end #def

    def write( c)
      self.class.contents = c # Set the class's '@' variable.
    end
    def print( s)
      write( s)
    end
    def close
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
    def test_file_name_save_chords
      Build.new( 0).save_chords() # Assume this uses MyFile to write.
      assert_equal( 'chords-0.txt', MyFile.file_name)
      assert_equal( 'w', MyFile.method)
    end
    def test_contents_save_chords
      Build.new( 0).save_chords()
      assert_equal( 'contents-N', MyFile.contents)
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
