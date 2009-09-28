require 'bit'
require 'chordutilities'
module GenerateNoteSpace
#-----------------------------
  class NecklaceWords
    include ChordUtilities
    include Enumerable
    def initialize( w)
          @width = w
      @good_words = (1..Bit::BIT_STATES ** @width).collect {|word| normalize( word, @width)}.sort!.uniq!
#print '@good_words '; p @good_words
    end

    def each
      @good_words.each {|word| yield word}
    end
  end #class NecklaceWords
#-----------------------------
  class Necklace
    attr_reader :roots,
                :word
    def initialize( w)
          @word = w
      @roots = Array.new( @@width, nil)
    end

    def Necklace.set_fixed( note_space)
      @@width = note_space.length
      @@most_significant_bit_value = note_space.most_significant_bit_value
    end

    def add_rooted_chord( word, chord)
#print 'word '; p word.to_s( 2)
#print 'word '; p word
      w = @word
      root = (0...@@width).detect do |i|
        maybe_root = w == word
        bit = 0 != w & @@most_significant_bit_value
        w &= ~@@most_significant_bit_value
        w <<= Bit::SINGLE_BIT
        w |= Bit::BIT_VALUE_1 if bit
        maybe_root
      end #detect i
      raise 'root was nil' if root.nil?
      @roots[ root] = chord
    end #def

    def to_s
#     '[' + (0...@@width).reject {|i| @roots.at( i).nil?}.join( ',') + ']'
      @word.to_s( 2)
    end

  end #class Necklace
#-----------------------------
  class Necklaces
    def initialize( note_space)
      Necklace.set_fixed( note_space)
      @necklaces = NecklaceWords.new( note_space.length).collect {|word| Necklace.new( word)}
    end

    def each
      @necklaces.each {|necklace| yield necklace}
    end

    def word_to_necklace( word)
      @necklaces.detect {|e| e.word == word}
    end
  end #class Necklaces
=begin
#-----------------------------
  class AllRoots
    def initialize( a)
          @all_necklace_chords = a
      width = @all_necklace_chords.width
      @all_necklace_chords.each do |necklace_chord|
        c = necklace_chord
        roots = (0...width).collect do |i|
          next unless Bit::BIT_VALUE1 == c & Bit::SINGLE_BIT
          root = Root.new( necklace_chord, i)
          c >>= Bit::SINGLE_BIT
          root
        end #collect i
      end #each necklace_chord
      roots.each do |chord|
      end #each chord
    end #def

    def each
      @all_necklace_chords.each {|e| yield e}
    end
  end #class AllRoots
=end
#-----------------------------
  class NoteSpace
    attr_reader :length,
                :necklaces,
                :note_names,
                :most_significant_bit_value,
    :minor_second, :major_second, :minor_third, :major_third, :fourth, :tritone, :fifth,
    :minor_sixth, :major_sixth, :minor_seventh, :major_seventh, :octave,
    :minor_ninth, :major_ninth, :minor_tenth, :major_tenth, :octave_tritone,
    :minor_sixteenth, :major_sixteenth, :minor_seventeenth, :major_seventeenth

    def initialize( length)
      if 12 == length 
        @minor_second, @major_second = 1, 2
        @minor_third, @major_third = 3, 4
        @fourth, @tritone, @fifth = 5, 6, 7
        @minor_sixth, @major_sixth = 8, 9
        @minor_seventh, @major_seventh = 10, 11
        @minor_ninth, @major_ninth = 13, 14
        @minor_tenth, @major_tenth = 15, 16
        @octave_tritone = 18
        @minor_sixteenth, @major_sixteenth = 25, 26
        @minor_seventeenth, @major_seventeenth = 27, 28

        @note_names = %w{G Ab A Bb B C C# D Eb E F F#}
        @octave = @length = @note_names.length
        @most_significant_bit_value = Bit::BIT_VALUE_1 << (@length - Bit::BIT_WIDTH)
print '@most_significant_bit_value.to_s( 2) '; p @most_significant_bit_value.to_s( 2)
        @necklaces = Necklaces.new( self)
      end # if
    end
  end #class NoteSpace
end #module GenerateNoteSpace