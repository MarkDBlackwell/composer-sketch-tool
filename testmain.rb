require 'test/unit'
require 'main'
=begin
#====================
# Got this from http://thinkingdigitally.com/archive/capturing-output-from-puts-in-ruby/
module Kernel
  def capture_stdout
    out = StringIO.new
    $stdout = out
    yield
    $stdout = STDOUT
    return out
  end
end #module Kernel
#====================
=end
#-----------------------------
  class ProgramTest < Test::Unit::TestCase
    def test_true
      assert true
    end

    def test_2
#      program = Main::Program.new( note_space_width = 2)
#      print s
#      program.run
    end

    def test_12
      program = Main::Program.new( note_space_width = 12)
#      print s
      program.run
    end

  end #class Test
