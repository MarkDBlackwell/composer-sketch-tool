require 'yaml'
require 'bit'
require 'chordutilities'
module GenerateNoteSpace
#-----------------------------
  class NecklaceWords
    include ChordUtilities
    include Enumerable
    def initialize( note_space)
      w =           note_space.width
      @good_words = (1..Bit::BIT_STATES ** w).collect {|word| normalize( word, w)}.sort!.uniq!
#print '@good_words '; p @good_words
    end

    def each
      @good_words.each {|word| yield word}
    end
  end #class NecklaceWords
#-----------------------------
  class Necklace
    attr_reader :expansion,
                :missing,
                :note_names,
                :root_numbers,
                :root_words,
                :roots,
                :word
    def initialize( w)
          @word = w
=begin
Any '1' bit can be a root.
A normalized word has MSB to LSB, G F# F E Eb D C# C B Bb A Ab.
The MSB is numbered 12, down to the LSB, which is numbered 1.
Root numbers example: if the word is rotated circularly 4 bits to the right (then the word
is no longer normalized), B then becomes 12 and all notes' bit indices diminish by four. With
this rightward shift of four bits, G is the root of the new rooted chord, and I call it
(rooted chord) number 4.
=end
# When I get Ruby 1.9, use Zip into Struc (if not in 1.8).
      @root_words = []
      @root_numbers = []
      expansion_numbers = []
      circle = @word
      symmetrical = false
      (0...@@width).each do |note|
        if @@most_significant_bit_value == circle & @@most_significant_bit_value
          expansion_numbers.push( note)
          unless symmetrical
            @root_words.push( circle)
            @root_numbers.push( note)
          end #unless
        end #if
        high_bit = 0 != circle & @@most_significant_bit_value
        circle &= ~@@most_significant_bit_value
        circle <<= Bit::BIT_WIDTH
        circle |= Bit::BIT_VALUE_1 if high_bit
        symmetrical |= circle == @word
      end #each note
      @expansion = expansion_numbers.join(',')
      @missing = (0...@@width).reject {|e| expansion_numbers.include?( e)}.join(',')
      @note_names = expansion_numbers.collect {|e| @@note_names.at( (@@width - e) % @@width)}.join(' ')
      @roots = Array.new( @root_words.length, nil)
    end

    def Necklace.set_fixed( note_space)
      @@width = note_space.width
      @@most_significant_bit_value = note_space.most_significant_bit_value
      @@note_names = note_space.note_names
    end

    def add_rooted_chord( unnormalized_word, chords)
#print 'unnormalized_word ', unnormalized_word, ' '; p unnormalized_word.to_s( 2)
#print 'chords.inspect '; p chords.inspect
#print 'unnormalized_word '; p unnormalized_word
      root_index = (0...@root_words.length).detect {|i| @root_words.at( i) == unnormalized_word}
#     @roots[ @root_numbers.at( root_index)] = chords
      @roots[ root_index] = [] if @roots[ root_index].nil?
      @roots[ root_index].concat( chords)
    end #def

    def to_s
#     '[' + (0...@@width).reject {|i| @roots.at( i).nil?}.join(',') + ']'
      @word.to_s( 2)
    end

  end #class Necklace
#-----------------------------
  class Necklaces
    attr_reader :length
    include Enumerable
    def initialize( note_space)
      Necklace.set_fixed( note_space)
      @necklaces = NecklaceWords.new( note_space).collect {|word| Necklace.new( word)}
      @length = @necklaces.length
    end

    def each
      @necklaces.each {|necklace| yield necklace}
    end

    def at( i)
      @necklaces.at( i)
    end

    def word_to_necklace( word)
      @necklaces.detect {|necklace| necklace.word == word}
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
    attr_reader :width,
                :necklaces,
                :note_names,
                :most_significant_bit_value,
    :a_little, :two_littles, :minor_third, :major_third, :third_octave_and_a_little, :half_octave, :fifth,
    :minor_sixth, :major_sixth, :minor_seventh, :major_seventh, :octave,
    :octave_and_a_little, :major_ninth, :minor_tenth, :major_tenth, :octave_and_a_half,
    :minor_sixteenth, :major_sixteenth, :minor_seventeenth, :two_and_a_third_octaves

    def initialize( width)
      if 12 == width
        @a_little, @two_littles = 1, 2
        @minor_third, @major_third = 3, 4
        @third_octave_and_a_little, @half_octave, @fifth = 5, 6, 7
        @minor_sixth, @major_sixth = 8, 9
        @minor_seventh, @major_seventh = 10, 11
        @octave_and_a_little, @major_ninth = 13, 14
        @minor_tenth, @major_tenth = 15, 16
        @octave_and_a_half = 18
        @minor_sixteenth, @major_sixteenth = 25, 26
        @minor_seventeenth, @two_and_a_third_octaves = 27, 28
        @note_names = %w{G Ab A Bb B C C# D Eb E F F#}
        @width = @octave = @note_names.length
        @most_significant_bit_value = Bit::BIT_VALUE_1 << (@width - Bit::BIT_WIDTH)
#print '@most_significant_bit_value.to_s( 2) '; p @most_significant_bit_value.to_s( 2)
        @necklaces = Necklaces.new( self)
      end # if
    end #def

    def load_necklaces( io_object)
        @necklaces = YAML::load( io_object)
    end #def

  end #class NoteSpace
end #module GenerateNoteSpace
