require 'test/unit'
require 'generatenotespace'
#-----------------------------
  class NecklaceWordsTest
    def test_it
    end
  end #class
#-----------------------------
  class NecklaceTest
    def test_it
    end
  end #class
#-----------------------------
  class NecklacesTest
    def test_it
    end
  end #class
#-----------------------------
  class Test1 < Test::Unit::TestCase
    def test_it
#      s = TestOfAssertionTest.new
      NoteSpaceLengthTwelveTest.new
      NoteSpaceLengthTwoTest.new
    end
  end #class
#-----------------------------
  class NoteSpaceLengthTwelveTest
    def initialize
#      n = note_space = GenerateNoteSpace::NoteSpace.new( length = 12)
#      n.
    end
  end #class
#-----------------------------
  class NoteSpaceLengthTwoTest
    def initialize
#      n = note_space = GenerateNoteSpace::NoteSpace.new( length = 2)
    end
  end #class
#-----------------------------
  class NoteSpaceTest
    def test_it
          @note_space = NoteSpaceLengthTwoTest.new
          @note_space = NoteSpaceLengthTwelveTest.new
    end
  end #class
