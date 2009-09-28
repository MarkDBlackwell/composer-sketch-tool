require 'test/unit'
#-----------------------------
  class AssertTest < Test::Unit::TestCase
    def test_ruby_testing
      assert true
    end
    def test_fail
      assert( true, 'Assertion was false.')
    end
    def test_raise
      assert_raise RuntimeError do
         raise 'test stub'
      end
    end
  end #class AssertTest
#-----------------------------
  class TestOfAssertionTest < Test::Unit::TestCase
    def test_it
#      s = AssertTest.new.test_ruby_testing
    end
  end #class TestOfAssertionTest
