require 'test/unit'
require 'build'
#load File.dirname(__FILE__) + '/example-program.rb'

# A file for tests requiring the unaltered program class, MyFile.

# Example class-instance variable:
# class C;class << self;attr_accessor :a,:b,:c;end;
# @a=5;self.b=6;def initialize;self.class.c=7;end;end;
# C.new;p [C.a,C.b,C.c] #--> [5,6,7]

class HasClassInstanceVariable
  class << self
    attr_accessor :a
  end
end

class TestClassInstanceVariable < Test::Unit::TestCase
  def setup
    @c = HasClassInstanceVariable
    @c.a = 1
  end
  def test_revaluing_class_instance_variable
    @c.a *= 5
    assert_equal( 5, @c.a)
  end
end

class TestMyFileActualWrite < Test::Unit::TestCase
  def setup
    @file_name = 'test-my-file-actual-write.txt' # Similar to class name.
    File.open( @file_name, 'w') {|file| file.write 'aaa'}
  end
  def test_actual_write
    a = read()
    assert_equal( 'aaa', a.last)
    MyFile.open( @file_name, 'w') {|file| file.write 'bbb'}
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
  end
end
