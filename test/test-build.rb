require 'test/unit'
require 'build'
#-----------------------------
class HasClassInstanceVariable
  class << self
    attr_accessor :a
  end
end #class HasClassInstanceVariable
#-----------------------------
class TestClassInstanceVariable < Test::Unit::TestCase
# Example class-instance variable:
# class C;class << self;attr_accessor :a,:b,:c;end;
# @a=5;self.b=6;def initialize;self.class.c=7;end;end;
# C.new;p [C.a,C.b,C.c] #--> [5,6,7]
  def setup
    @c = HasClassInstanceVariable
    @c.a = 1
  end

  def test_revaluing_class_instance_variable
    @c.a *= 5
    assert_equal( 5, @c.a)
  end #def
end #class TestClassInstanceVariable
#-----------------------------
class TestMyFileActualWrite < Test::Unit::TestCase
  def setup
    @file_name = 'test-my-file-actual-write.txt' # Similar to class name.
    File.open( @file_name, 'w') {|file| file.write 'aaa'}
  end
  def test_actual_write
    a = read()
    assert_equal( 'aaa', a.last)
    InvokeUtilities::MyFile.open( @file_name, 'w') {|file| file.write 'bbb'}
#   Process.exit! # Exit without being trapped by Test::Unit.
    a = read()
    assert_equal( 1, a.length)
    assert_equal( 'bbb', a.last)
  end
  def teardown # After all test methods.
    File.delete( @file_name)
  end
  private
  def read
    result = nil # Expand scope.
    File.open( @file_name, 'r') {|file| result = file.readlines}
    result
  end #def
end #class TestMyFileActualWrite
#-----------------------------
class TestBuildLogger < Test::Unit::TestCase
  def setup
    @file_name = 'log/build.txt'
    File.open( @file_name, 'r') {|f| @before = f.readlines.length}
    Invoke::Build.new( 0) # Assume this uses MyLogger to log.
  end

  def test_was_anything_actually_written
    after = nil
    File.open( @file_name, 'r') {|f| after = f.readlines.length}
    assert_equal( 1, after - @before)
  end #def
end #class TestLoggerBuild
