=begin
Thirds Chords
Author: Mark D. Blackwell.
Date started writing: March 21, 2009.
Date last modified: March 22, 2009.
Copyright (c) 2009 Mark D. Blackwell.

G B Eb(D) F# A C# F(E) Ab C E(Eb) (D-F): Bb
With no notes found since, stop; report through last found.
Start with no gaps.
Then add 1 gap of 1 third in all positions,
2 gaps of 1 third.
Or, loop through chords.
No gaps, eleven thirds.
No duplicated notes.
0 0 1 0 0 1 0 0 1 0 0
1 1
1 0 0 1 0 1 0 0 1 0 0
0 1
1 1
0 0 1
1 0 1
0 1 1

G Ab A
0 1 2

All sequences of 11 minor and major thirds.
No more than two (2) major thirds in a row.
No more than three (3) minor thirds in a row.
(Avoid 12.)
0=minor, 1=major.
Stop if a note is duplicated and give the left-out notes.
11-bit binary numbers.
Are 2**11 = 2048 raw sequences.
Any permutation of 4's and 3's make 13 (minor ninth)?
Yes: G Bb C# E Ab = 3,3,3,4.
Any combination of 4 and 3 3's.
Also avoid 12.
Avoid the same notes.
Stop with all 12.
How to avoid infinite loop?
If at instruction comes to same note, not found.

generate_patterns
No gaps.
Eleven thirds.
No duplicated notes.
Loop through 2**11 chords
Keep good ones; reject bad ones.

require necklacechords
require thirdschords
require printer
require compositionfileio
namespace thirdschords
Use special processing for gaps; keep them out of chord_word.
Use Enumerable.
a = All_chords.new
a.each {|e| p e}
class gaps
Chord length not extended, only gaps intruduced.
If 11 thirds, then 10 places for gaps; excludes G.
Not shortening on the right, high-pitch, side.
Thus, not the last note, either, thus 9 places to put gaps.
Experience shows that 2-space gaps are the biggest found.
Minor thirds need not be accommodated --yes, they do, in order to cut different notes.
3-space gaps accommodate diminished chords, like G Bb C# E Ab becomes G _ _ _ Ab.
Experience shows 4 total spaces are the most meeded.
How many combinations are there of 4 drawn from 9 things?
Permutations of 9 is 9!; permutations of 4 is 4!.
Permutations of 4 drawn from 9 is 9!/(9-4)! = 9!/5!.
9 first choices, ... 6 fourth choices.
Number of permutations of these 4 is 4!, so, to get the number of combinations of these 4, divide by 4!.
So, 9!/(5!x4!) = 9x8x7x6/(4x3x2) = 3x7x6 = 9x2x7 = 2x3**2x7 =2x63 = 126.
Combinations of 5 drawn from 9 is 9!/((9-5)!x5!), also 126.
Of 6, 9!/((9-6)!x6!) = 9x8x7/(3x2) = 3x4x7 =84.
Need all from none up through 5.
Might as well do 512, removing ones that have too many spaces or too long stretches of gap.
Shift a bit word, looking for 4-space gaps (=15) and for more than 4 total 1-bits.
Generate gap words (10 bits = thirds_length - 1).
Shift through, checking 4-bit groupings and 1-bits.
Keep the good ones.
Keep and apply to all the thirds-length (=11) chords.

Processing one from each length, counted:
sorted_beginnings.collect {|e| e.length} [1, 2, 7, 26, 29, 13, 1]
gap_patterns.length 351
beginning [0]
diff 2931732
gap_patterns.length 198
beginning [0, 5]
diff 520313
gap_patterns.length 107
beginning [0, 10, 15]
diff 118281
gap_patterns.length 56
beginning [0, 11, 13, 15]
diff 27448
gap_patterns.length 29
beginning [0, 9, 11, 19, 20]
diff 2770
gap_patterns.length 15
beginning [0, 9, 11, 19, 20, 22]
diff 1364
gap_patterns.length 8
beginning [0, 7, 9, 11, 15, 20, 22]
diff 316
Chord.detail_count 3602224

extensions.length 718848
categorized_beginnings.collect {|a| a.length} [1, 2, 7, 26, 29, 13, 1]
@beginnings.first.length 1
extension_lengths 11
@@extension_categories.collect {|a| a.length} [0, 0, 0, 0, 590, 2753, 3255, 2368, 1093, 315, 42]
@@extension_categories.collect {|a| a.length} [0, 0, 0, 106, 964, 1681, 1684, 1041, 399, 74]
@@extension_categories.collect {|a| a.length} [0, 0, 27, 300, 763, 984, 741, 348, 70]
@@extension_categories.collect {|a| a.length} [0, 1, 44, 244, 471, 462, 291, 70]
@@extension_categories.collect {|a| a.length} [0, 4, 48, 175, 228, 179, 72]
@@extension_categories.collect {|a| a.length} [0, 3, 48, 94, 93, 42]
@@extension_categories.collect {|a| a.length} [0, 11, 37, 48, 24]
@@categorized_extensions.collect {|a| a.length} [12800, 51616, 89792, 118584, 131988, 166738, 101012, 37342, 8020, 914, 42]
=end
#=============================
module Bit
  SINGLE_BIT = 1
  BIT_STATES = 2
  BIT_VALUE_0 = 0
  BIT_VALUE_1 = 1
end #module
#=============================
module Necklace
#-----------------------------
  class Normalized_chord
    def initialize( chord)
      @value = '' # Is stub.
    end

    def to_s
      @value
    end
  end #class
end #module
#=============================
module Third
#-----------------------------
  class All_chords
    include Enumerable
    def initialize( w)
      @width = w
      @thirds_relative_chords = Array.new
      have = Array.new( Harmony::OCTAVE)
      (0...Bit::BIT_STATES ** @width).each do |word|
        thirds = (0...@width).collect {bit_value = word & Bit::SINGLE_BIT; word >>= Bit::SINGLE_BIT; bit_value}
        have.fill( false)
        note = 0
        relative_chord = thirds.collect do |third|
          case third
            when Bit::BIT_VALUE_0; note += Harmony::MAJOR_THIRD
            when Bit::BIT_VALUE_1; note += Harmony::MINOR_THIRD
          end #case
          next if have.at( note % Harmony::OCTAVE) # Skip this third's note.
          have[ note % Harmony::OCTAVE] = true
          note
        end #do third
        relative_chord.compact! # Remove nil's from next's.
        @thirds_relative_chords.push( relative_chord) unless @thirds_relative_chords.include?( relative_chord)
      end #do word
    end #def

    def each
      @thirds_relative_chords.each {|e| yield e}
    end

    def each_index
      @thirds_relative_chords.each_index {|i| yield i}
    end

    def length
      @thirds_relative_chords.length
    end

    def width
      @width
    end

  end #class
end #module
#=============================
module Gap
  MAX_GAPS = 5
#-----------------------------
  class All_constellation_words
    include Enumerable
    def initialize( n)
#     raise NoMethodError.new( 'All_constellation_words is an abstract class and cannot be instantiated') if self.class == All_constellation_words
#print 'All_constellation_words self.class '; p self.class
      @number_of_bits = n
      @length = Bit::BIT_STATES ** @number_of_bits
    end

    def each
      (@length - 1).downto( 0) {|word| yield word}
    end
  end #class
#-----------------------------
  class All_constellations
    EXCESSIVE_TOGETHER = 0b1111 # Least significant several bits.
    include Enumerable
    def initialize( w)
      @width = w
      @good_words = pick
    end

    def each
      @good_words.each {|e| yield e}
    end

    def length
      @good_words.length
    end

    def width
      @width
    end

    private
    def pick
      All_constellation_words.new( @width).reject do |word|
        count_gaps = 0
        word_bad = false
        @width.times do
          count_gaps += 1 if Bit::BIT_VALUE_0 == word & Bit::SINGLE_BIT # Least significant bit.
          word_bad = true if count_gaps > MAX_GAPS || 0 == word & EXCESSIVE_TOGETHER
          break if word_bad # Checking later bits won't fix this bad word.
          word >>= Bit::SINGLE_BIT
        end #do times
        word_bad
      end #do word
    end #def

  end #class
#-----------------------------
  class All_constellation_positions
    include Enumerable
    def initialize( g)
      @good_words = g
      @positions = @good_words.collect {|word| bits_to_positions( word)}
    end

    def each
#print "All_constellation_positions#each called\n"
      @positions.each {|e| yield e}
    end

    def each_index
#     @good_words.length.times {|i| yield i}
      @positions.each_index {|i| yield i}
    end

    def length
#     @good_words.length
      @positions.length
    end

    private
    def bits_to_positions( word)
      word <<= Bit::SINGLE_BIT
      (0...@good_words.width).collect {|i| Bit::BIT_VALUE_1 == Bit::SINGLE_BIT & (word >>= Bit::SINGLE_BIT) ? i : nil}.compact # Zero-based; test least significant first.
    end

  end #class
end #module
#=============================
module Harmony
  NOTE_NAMES = %w{G Ab A Bb B C C# D Eb E F F#}
  MINOR_THIRD = 3
  MAJOR_THIRD = 4
  TRITONE = 6
  OCTAVE = NOTE_NAMES.length
  MINOR_NINTH = 13
  MAJOR_NINTH = 14
  BEGINNINGS =[ # G, followed by:
#-----11-----------------------F#
#[ 0, 11, 13, 19], # F# Ab D - (Gap covers.)
 [ 0, 11, 13, 15], # F# Ab Bb
#[ 0, 11], # F# - (Gap covers.)
#-----10-----------------------F
 [ 0, 10, 15], # F Bb
 [ 0, 10, 13, 15], # F Ab Bb
#[ 0, 10], # F - (Gap covers.)
#-----9------------------------E
#[ 0, 9, 15], # E Bb - (Gap covers.)
#-----9--11--------------------E F#
 [ 0, 9, 11, 19, 20, 22], # E F# D Eb F (U)
 [ 0, 9, 11, 19, 20], # E F# D Eb (U)
#[ 0, 9, 11, 19], # E F# D (U) - (Gap covers.)
 [ 0, 9, 11, 14, 16], # E F# A B (U)
#[ 0, 9, 11, 13, 19], # E F# Ab D - (Gap covers.)
 [ 0, 9, 11, 13, 15], # E F# Ab Bb (U)
 [ 0, 9, 11], # E F# (U)
#[ 0, 9], # E - (Gap covers.)
#-----8------------------------Eb
#[ 0, 8, 19], # Eb D - (Gap covers.)
#[ 0, 8, 15], # Eb Bb - (Gap covers.)
#[ 0, 8, 13, 19], # Eb Ab D - (Gap covers.)
 [ 0, 8, 13, 15], # Eb Ab Bb
 [ 0, 8, 13], # Eb Ab
#-----8--11--------------------Eb F#
#[ 0, 8, 11, 19], # Eb F# D (U) - (Gap covers.)
 [ 0, 8, 11, 17, 19], # Eb F# C D (U)
#[ 0, 8, 11, 17], # Eb F# C (U) - (Gap covers.)
 [ 0, 8, 11, 16], # Eb F# B (U)
#[ 0, 8, 11, 13, 19], # Eb F# Ab D - (Gap covers.)
 [ 0, 8, 11, 13, 18], # Eb F# Ab C# (U)
 [ 0, 8, 11, 13, 15], # Eb F# Ab Bb (U)
 [ 0, 8, 11, 13], # Eb F# Ab
#[ 0, 8], # Eb (U) - (Gap covers.)
#-----7------------------------D
#[ 0, 7, 11, 17], # D F# C (U) - (Gap covers.)
 [ 0, 7, 11, 13, 15], # D F# Ab Bb (U)
 [ 0, 7, 11, 13], # D F# Ab (U)
 [ 0, 7, 10, 16, 18], # D F B C# (U)
#[ 0, 7, 10, 16], # D F B (U) - (Gap covers.)
#-----7--9---------------------D E
#[ 0, 7, 9, 11, 18], # D E F# C# (U) - (Gap covers.)
 [ 0, 7, 9, 11, 15, 20, 22], # D E F# Bb Eb F (U)
 [ 0, 7, 9, 11, 15, 20], # D E F# Bb Eb (U)
 [ 0, 7, 9, 11, 14, 16], # D E F# A B (U)
 [ 0, 7, 9, 11, 13, 15], # D E F# Ab Bb (U)
 [ 0, 7, 9, 11, 13], # D E F# Ab (U)
 [ 0, 7, 9, 11], # D E F# (U)
 [ 0, 7, 9], # D E (U)
#[ 0, 7], # D (U) - (Gap covers.)
#-----6------------------------C#
 [ 0, 6, 10, 14, 15, 17], # C# F A Bb C (U)
 [ 0, 6, 10, 14, 15], # C# F A Bb (U)
#-----6--9---------------------C# E
 [ 0, 6, 9, 14, 16, 17], # C# E A B C (U)
 [ 0, 6, 9, 14, 16], # C# E A B (U)
 [ 0, 6, 9, 14], # C# E A (U)
 [ 0, 6, 9, 11], # C# E F# (U)
#------------------------------
 [ 0, 6, 8, 10], # C# Eb F (U)
 [ 0, 6, 8], # C# Eb (U)
#[ 0, 6], # C# (U) - (Gap covers.)
#-----5------------------------C
#[ 0, 5, 15], # C Bb - (Gap covers.)
#[ 0, 5, 13, 19], # C Ab D - (Gap covers.)
 [ 0, 5, 13, 15], # C Ab Bb
#[ 0, 5, 13], # C Ab - (Gap covers.)
#-----5--11--------------------C F#
 [ 0, 5, 11, 14, 16], # C F# A B (U)
#[ 0, 5, 11, 13, 19], # C F# Ab D - (Gap covers.)
 [ 0, 5, 11, 13, 15], # C F# Ab Bb
 [ 0, 5, 11, 13], # C F# Ab
#[ 0, 5, 11], # C F# (U) - (Gap covers.)
#-----5--9---------------------C E
 [ 0, 5, 9, 16, 19, 20], # C E B D Eb (U)
#[ 0, 5, 9, 16], # C E B (U) - (Gap covers.)
#[ 0, 5, 9, 15], # C E Bb - (Gap covers.)
 [ 0, 5, 9, 14, 16, 18], # C E A B C# (U)
 [ 0, 5, 9, 14, 16], # C E A B (U)
 [ 0, 5, 9, 14], # C E A (U)
#[ 0, 5, 9, 13, 19], # C E Ab D - (Gap covers.)
 [ 0, 5, 9, 13, 15], # C E Ab Bb
#[ 0, 5, 9, 11, 13, 19], # C E F# Ab D - (Gap covers.)
 [ 0, 5, 9, 11, 13, 15], # C E F# Ab Bb (U)
 [ 0, 5, 9, 11, 13], # C E F# Ab
 [ 0, 5, 9, 11], # C E F#
#-----5--8---------------------C Eb
#[ 0, 5, 8, 16], # C Eb B (U) - (Gap covers.)
#[ 0, 5, 8, 15], # C Eb Bb - (Gap covers.)
#[ 0, 5, 8, 13, 19], # C Eb Ab D - (Gap covers.)
 [ 0, 5, 8, 13, 15], # C Eb Ab Bb (U)
 [ 0, 5, 8, 13], # C Eb Ab
 [ 0, 5, 8, 10, 15], # C Eb F Bb (U)
 [ 0, 5, 8, 10], # C Eb F (U)
#-----5--7---------------------C D
#[ 0, 5, 7, 15], # C D Bb - (Gap covers.)
#[ 0, 5, 7, 13, 19], # C D Ab D
 [ 0, 5, 7, 13, 15], # C D Ab Bb
#[ 0, 5, 7, 13], # C D Ab - (Gap covers.)
#[ 0, 5, 7, 11, 13, 19], # C D F# Ab D - (Gap covers.)
 [ 0, 5, 7, 11, 13, 15], # C D F# Ab Bb
 [ 0, 5, 7, 11, 13], # C D F# Ab
 [ 0, 5, 7], # C D (U)
 [ 0, 5], # C (U)
#-----4------------------------B
#[ 0, 4, 15], # B Bb - (Gap covers.)
 [ 0, 4, 13, 15], # B Ab Bb (U)
#-----4--11--------------------B F#
 [ 0, 4, 11, 14, 15], # B F# A Bb (U)
#[ 0, 4, 11, 13, 19], # B F# Ab D - (Gap covers.)
 [ 0, 4, 11, 13, 15], # B F# Ab Bb (U)
 [ 0, 4, 11, 13], # B F# Ab (U)
#[ 0, 4, 11], # B F# (U) - (Gap covers.)
#------------------------------
 [ 0, 4, 10, 13, 15], # B F Ab Bb (U)
#[ 0, 4, 10], # B F (U) - (Gap covers.)
#-----4--9---------------------B E
#[ 0, 4, 9, 15], # B E Bb (U) - (Gap covers.)
#[ 0, 4, 9, 13, 19], # B E Ab D - (Gap covers.)
 [ 0, 4, 9, 13, 15], # B E Ab Bb (U)
 [ 0, 4, 9, 11, 13, 15], # B E F# Ab Bb (U)
 [ 0, 4, 9, 11], # B E F# (U)
 [ 0, 4, 9, 15], # B E (U)
#-----4--8---------------------B Eb
#[ 0, 4, 8, 15], # B Eb Bb (U) - (Gap covers.)
#[ 0, 4, 8, 13, 19], # B Eb Ab D - (Gap covers.)
 [ 0, 4, 8, 13, 15], # B Eb Ab Bb
 [ 0, 4, 8, 13], # B Eb Ab
 [ 0, 4, 8, 11, 13, 15], # B Eb F# Ab Bb (U)
 [ 0, 4, 8, 11, 13], # B Eb F# Ab
 [ 0, 4, 8, 10], # B Eb F (U)
#-----4--7---------------------B D
#[ 0, 4, 7, 15], # B D Bb (U) - (Gap covers.)
#[ 0, 4, 7, 14], # B D A (U) - (Gap covers.)
 [ 0, 4, 7, 13, 15, 17], # B D Ab Bb C (U)
 [ 0, 4, 7, 13, 15], # B D Ab Bb (U)
#[ 0, 4, 7, 13], # B D Ab (U) - (Gap covers.)
#-----3------------------------Bb
#[ 0, 3, 13], # Bb Ab - (Gap covers.)
#[ 0, 3, 11], # Bb F# (U) - (Gap covers.)
 [ 0, 3, 9, 11], # Bb E F# (U)
#[ 0, 3, 9], # Bb E (U) - (Gap covers.)
#-----3--8---------------------Bb Eb
#[ 0, 3, 8, 13, 19], # Bb Eb Ab D - (Gap covers.)
 [ 0, 3, 8, 13], # Bb Eb Ab
 [ 0, 3, 8, 11, 13], # Bb Eb F# Ab
 [ 0, 3, 8, 10], # Bb Eb F
 [ 0, 3, 8], # Bb Eb
#------------------------------
#[ 0, 3, 7, 13], # Bb D Ab - (Gap covers.)
 [ 0, 3, 7, 11, 13], # Bb D F# Ab
 [ 0, 3, 7, 9], # Bb D E
#[ 0, 3, 6, 14], # Bb C# A (U) - (Gap covers.)
#-----2------------------------A
#[ 0, 2, 11], # A F# - (Gap covers.)
 [ 0, 2], # A
#------------------------------
 [ 0], # Just G (U)
#[ 0, 3], [ 0, 4], # Test of the 'do not need this chord' message functionality.
]
#-----------------------------
  class Chord
@@detail_count = 0
    def initialize( v)
      @value = v
    end

    def accumulate_unique( beginning)
    end

    def breadth
      @value.last
    end

    def handle( beginning) # The argument is used in subclasses.
@@detail_count += 1
    end

    def gaps_count
      (1..3).inject( 0) {|memo, multiple| memo +
      (1...@value.length).find_all {|i|
           @value.at( i    ) -
           @value.at( i - 1) >  multiple * MAJOR_THIRD}.length}
    end

    def length
      @value.length
    end

    def missing
      to_one_octave = @value.collect {|e| e % OCTAVE}
      Chord.new(( 0...OCTAVE).reject {|e| to_one_octave.include?( e)})
    end

    def notes_per_octave
      @value.length/(@value.last.to_f/OCTAVE)
    end

    def pairings_count( interval)
      @value.inject( 0) {|memo, low| memo + @value.find_all {|high| low + interval == high}.length}
    end

    def to_s
      @value.collect {|note| Note.new( note).to_s}.join( ' ')
    end

    def format_it( cb)
      @chord_beginning = cb
      to_s +
      ' - ' +
      '[' + @chord_beginning.join(',') + ']' +
      ' - ' +
      '(' +
      'm9-' + pairings_count( MINOR_NINTH).to_s +
      ' ' +
      'j9-' + pairings_count( MAJOR_NINTH).to_s +
      ' ' +
      't-' + pairings_count( TRITONE).to_s +
      ' ' +
      'g-' + gaps_count.to_s +
      ' ' +
      's-' + breadth.to_s + # Span.
      ' ' +
      'd-' + ((100 * notes_per_octave).round / 100.0).to_s + # Density
      ')' +
      ' - ' +
      '(' + missing.to_s + ')' +
      ' - ' +
      '[' + Necklace::Normalized_chord.new( @chord).to_s + ']' +
      "\n"
    end
    def Chord.heading
      'chord' +
      ' - ' +
      '[' + 'beginning' + ']' +
      ' - ' +
      '(' +
      'm9-' + 'minor_ninths' +
      ' ' +
      'j9-' + 'major_ninths' +
      ' ' +
      't-' + 'tritones' +
      ' ' +
      'g-' + 'gaps' +
      ' ' +
      's-' + 'span' +
      ' ' +
      'd-' + 'density' +
      ')' +
      ' - ' +
      '(' + 'missing notes' + ')' +
      ' - ' +
      '[' + 'normal form' + ']' +
      "\n"
    end

def Chord.detail_count
@@detail_count
end

=begin # Keep these possibly useful methods.
    def +( a)
      Chord.new( @value + a.value)
    end #def

    def at( i)
      @value.at( i)
    end

    def each
      @value.each {|e| yield e}
    end

    def last
      @value.last
    end

    def value
      @value
    end
=end
  end #class
#-----------------------------
  class Chord_beginning
    def Chord_beginning.chord_class=( c)
      @@chord = c
    end

    def initialize( b)
      @beginning = b
#print '@beginning '; p @beginning
#print '@beginning.length '; p @beginning.length
      @beginning_have = @beginning.inject( Array.new( OCTAVE, false # Start by assuming that @beginning has no notes.
      )) {|memo, note| memo[ note % OCTAVE] = true; memo}
#print '@beginning_have '; p @beginning_have
      @beginning_last = @beginning.last
    end

    def handle( array_of_arrays_of_lengthenings)
      array_of_arrays_of_lengthenings.each do |array_of_lengthenings|
        relative_extension_break = false
        array_of_lengthenings.reverse_each do |relative_extension| # Growing longer.
#print 'relative_extension '; p relative_extension
          relative_extension.each do |relative_note|
            (relative_extension_break = true; break) if @beginning_have.at(( 
            @beginning_last + relative_note) % OCTAVE) # This bad note will exist in later lengthenings.
          end #do relative_note
          break if relative_extension_break # Try the next array_of_lengthenings.
          @@chord.new( @beginning + relative_extension.collect {|relative_note|
          @beginning_last + relative_note}).handle( @beginning)
        end #do relative_extension
#print '@@chord.detail_count '; p @@chord.detail_count
      end #do array_of_lengthenings
    end

  end #class
#-----------------------------
  class Chord_beginnings
    THIRDS =[ MINOR_THIRD, MAJOR_THIRD]
    include Enumerable
    def initialize
      @chord_beginnings = part_is_generable? ? [] : BEGINNINGS
    end

    def each
      @chord_beginnings.each {|a| yield a}
    end

    private
    def part_is_generable?
      result = false
      BEGINNINGS.each do |a|
        (result = true; p 'Do not need this chord:', a) if a.length >= 2 and
           THIRDS.include?( last_interval = a.last - a[    a.length -  2])
        (result = true; p 'Duplicate chord:', a) if BEGINNINGS.find_all {|e| e == a}.length >= 2
      end #do a
      result
    end
  end #class
#-----------------------------
  class Chord_beginning_category
# Relies on its objects being created in order of non-decreasing @beginnings length.
    @@first_time = true
    def initialize( b)
      @beginnings = b
# Relies on max_thirds_length never increasing.
#print '@beginnings.first.length '; p @beginnings.first.length
#     max_thirds_length = OCTAVE + Gap::MAX_GAPS - @beginnings.first.length # All same length.
      max_thirds_length = OCTAVE - @beginnings.first.length # All same length.
      if @@first_time
        @@first_time = false
        @@extension_categories = product(
        Third::All_chords.new(       max_thirds_length), 
        Gap::All_constellation_positions.new(
        Gap::All_constellations.new( max_thirds_length - 1)), # The last place is not properly a gap.
                                     max_thirds_length)
#print '@@extension_categories.length '; p @@extension_categories.length
print '@@extension_categories.collect {|a| a.length} '; p @@extension_categories.collect {|a| a.length}
# Is inject ... at( i) slow?
# Is array creation (of [--, i]) slower than using struc?
# Add shrinkage to length categories and Gap-Third combination categories.
#Get lengths.
        @@extensions = []
        @@extension_categories.clone.each do |category| # Works with method, clear on its objects.
          category.each do |extension|
#print 'extension '; p extension
            shrinking = extension
            pushable_extensions = []
            (extension.length - 1).times do # Down through a length of 1 to handle gaps at the first place.
              shrinking = shrinking.clone # New object, for pushing into two arrays.
              shrinking.pop
#print 'shrinking '; p shrinking
              c = @@extension_categories.at( shrinking.length - 1)
#print 'shrinking.length '; p shrinking.length
              break if c.include?( shrinking) # Shorter ones will be there, too.
              c.push( shrinking)
              pushable_extensions.push( shrinking) # Same object.
            end #do times
            @@extensions.push( pushable_extensions)
          end #do extension
        end #do category
print "finished first time\n"
      else
        (max_thirds_length + 1..@@extension_categories.length).each do |i|
          @@extension_categories.at( i - 1).each {|a| a.clear} # Keep object (not value) for arrays holding it.
          @@extension_categories.delete_at( i - 1) # Delete reference to object (not object).
        end #do i
        @@extensions.each {|a| a.reject! {|e| e.empty?}}
        @@extensions.reject! {|e| e.empty?}
      end #if
    end

    def handle
detail_count_difference = Chord.detail_count
#     [@beginnings.first].each {|beginning|
      @beginnings.each {|beginning|
        Chord_beginning.new( beginning).handle( @@extensions)}
detail_count_difference = Chord.detail_count - detail_count_difference
print 'detail_count_difference '; p detail_count_difference
    end #def

    private
    def product( thirds_chords, gap_patterns, el)
      extension_lengths = el # 1 through maximum length.
print 'thirds_chords.length '; p thirds_chords.length
      octave_something = OCTAVE - @beginnings.first.length
      categorized_extensions = Array.new( extension_lengths) {[]}
      have = Array.new( OCTAVE)
      chord = Array.new
      thirds_chords.each do |thirds_chord|
#print 'thirds_chord is nil ' if thirds_chord.nil?
        full_length = [thirds_chord.length, octave_something].min
#       full_length = [thirds_chord.length, octave_something].max
#print 'full_length '; p full_length
        space_out_sufficient = thirds_chord.length - 1 - Gap::MAX_GAPS
#print 'thirds_chord '; p thirds_chord
#print 'thirds_chord.length '; p thirds_chord.length
        gap_patterns.each do |positive_pattern|
#print 'positive_pattern '; p positive_pattern
# Get valid length.
#         have = Array.new( OCTAVE, false)
          have.fill( false)
#         chord = []
          chord.clear
          save_space_out = 0
          positive_pattern.each do |space_out|
            save_space_out = space_out
            note = thirds_chord.at( space_out)
            break if note.nil? || have.at( note % OCTAVE) # Going farther down this chord still contains this bad note, so process the chord.
            chord.push( note)
            have[ note % OCTAVE] = true
          end #do space_out
          c = categorized_extensions.at( chord.length - 1)
          c.push( chord) unless c.include?( chord)
#         next if chord.length >= full_length # Try the next positive_pattern.
#         if save_space_out >= space_out_sufficient
            note = thirds_chord.last # Both with and without the last note.
#           next if have.at( note % OCTAVE) # Try the next positive_pattern.
            chord.push( note)
            c = categorized_extensions.at( chord.length - 1)
            c.push( chord) unless c.include?( chord)
#         end #if
#(G) B Eb F# Bb D F A C# E Ab C
#try_debug = [4,8,11,15,19,22,26,30,33,37,41]
#if chord.slice( 0...try_debug.length) == try_debug
#print 'thirds_chord '; p thirds_chord
#print 'positive_pattern '; p positive_pattern
#print 'chord '; p chord; print "\n"
#end #if
        end #do positive_pattern
      end #do thirds_chord
#(G) B Eb F# Bb D F A C# E
#categorized_extensions.each do |extension_category|
#matched = extension_category.find_all do |chord|
#a = [4,8,11,15,19,22,26,30,33,37]
#chord.slice( 0...a.length) == a
#end #do chord
#matched.each {|e| print 'chord '; p e}
#end #do extension_category
#abort
      categorized_extensions
    end #def
  end #class
#-----------------------------
  class Chord_beginning_categories
    def initialize
      length_categories = (beginnings = Chord_beginnings.new).collect {|a| a.length}.sort!.uniq!
      length_categories = [] if length_categories.nil?
#print 'length_categories '; p length_categories
      categorized_beginnings = beginnings.inject( Array.new( length_categories.length) {[]}
      ) {|memo, a| memo[ length_categories.index( a.length)].push( a); memo}
#print 'categorized_beginnings '; p categorized_beginnings
print 'categorized_beginnings.collect {|a| a.length} '; p categorized_beginnings.collect {|a| a.length}
      @beginning_categories = categorized_beginnings.inject( []) {|memo, a| memo.push(
      Chord_beginning_category.new( a))}
#@beginning_categories.each {|a| print 'a.beginnings.length '; p a.beginnings.length}
    end #def

    def each
#     (6...@beginning_categories.length).each {|i| yield @beginning_categories.at( i)}
      @beginning_categories.each {|a| yield a}
    end

    def handle
      print Chord.heading
      each {|beginning_category| beginning_category.handle}
print 'Chord.detail_count '; p Chord.detail_count
    end
  end #class
#-----------------------------
  class Note
    def initialize( v)
      @value = v
    end
    def to_s
      NOTE_NAMES.at( @value % OCTAVE)
    end
  end #class
#-----------------------------
  class Chord_print < Chord
    def handle( beginning); super
      print format_it( beginning)
    end
  end #class
#-----------------------------
  class Chord_accumulate < Chord
    def handle( beginning); super
      accumulate_unique( beginning)
    end
  end #class
end #module
#=============================
module Tree
#print ' '; p 

=begin
CANDIDATE_INTERVALS = (1..11).to_a
MINIMUM_GAP_INTERVAL = 3
MAX_GAPS = 3
MAX_HIGHEST_NOTE = 10
nog count
0 232
1 568
2 216
3 8
all 1024
439 node.dump "nog: 3 i: [0,1,3,3,3] hn: 10"
823 node.dump "nog: 3 i: [0,3,1,3,3] hn: 10"
871 node.dump "nog: 3 i: [0,3,3,1,3] hn: 10"
877 node.dump "nog: 3 i: [0,3,3,3,1] hn: 10"
878 node.dump "nog: 3 i: [0,3,3,3] hn: 9"
879 node.dump "nog: 3 i: [0,3,3,4] hn: 10"
887 node.dump "nog: 3 i: [0,3,4,3] hn: 10"
951 node.dump "nog: 3 i: [0,4,3,3] hn: 10"
#-----------------------------
Protecting against even one minor ninth:
CANDIDATE_INTERVALS [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
MINIMUM_GAP_INTERVAL 6
MAX_GAPS 2
MAX_HIGHEST_NOTE 48
@@count 43884

CANDIDATE_INTERVALS [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
MINIMUM_GAP_INTERVAL 9
MAX_GAPS 2
MAX_HIGHEST_NOTE 36
@@count 66049

CANDIDATE_INTERVALS [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
MINIMUM_GAP_INTERVAL 9
MAX_GAPS 2
MAX_HIGHEST_NOTE 40
@@count 126531

CANDIDATE_INTERVALS [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
MINIMUM_GAP_INTERVAL 9
MAX_GAPS 2
MAX_HIGHEST_NOTE 44
@@count 268652

CANDIDATE_INTERVALS [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
MINIMUM_GAP_INTERVAL 9
MAX_GAPS 2
MAX_HIGHEST_NOTE 48
@@count 456685
=end
  CANDIDATE_INTERVALS = (1..11).to_a
print 'CANDIDATE_INTERVALS '; p CANDIDATE_INTERVALS
  MINIMUM_GAP_INTERVAL = 9
print 'MINIMUM_GAP_INTERVAL '; p MINIMUM_GAP_INTERVAL
  MAX_GAPS = 2
print 'MAX_GAPS '; p MAX_GAPS
  MAX_HIGHEST_NOTE = 14
print 'MAX_HIGHEST_NOTE '; p MAX_HIGHEST_NOTE
#-----------------------------
  class Node
    def initialize( p, hn, nog, i)
        @parent = p
        @highest_note = hn
        @number_of_gaps = nog
        @intervals = i
      @absolutes = @intervals.inject( nil) {|memo, e| memo.nil? ? [ e] : memo.push( memo.last + e)}
      @have_notes = @intervals.inject( nil) {|memo, e| memo.nil? ? [ e % Harmony::OCTAVE] : memo.push( memo.last + e % Harmony::OCTAVE)}
#print '@have_notes '; p @have_notes
#     alert 'new called' if caller != Node.make_new_node
      @candidate_intervals_index = 0
      step_down_branch
    end

    def Node.make_new_node( p, hn, nog, i)
      node = Node.new( p, hn, nog, i)
      @@processing_node
    end #def

    def create_sibling
      return nil if @parent.nil?
      @parent.create_next_child
    end

    def dump
      'ng: ' + @number_of_gaps.to_s +
      ' ' +
      'i: [' + @intervals.join(',') + ']' +
      ' ' +
      'hn: ' + @highest_note.to_s
    end

    protected
    def create_next_child
# At parent level.
      @candidate_intervals_index += 1
      return self if CANDIDATE_INTERVALS.length == @candidate_intervals_index
      return create_sibling if @candidate_intervals_index > CANDIDATE_INTERVALS.length
      interval = CANDIDATE_INTERVALS.at( @candidate_intervals_index)
      highest_note = @highest_note + interval
      return create_next_child if check_stuff( highest_note)
      number_of_gaps = @number_of_gaps
      if interval >= MINIMUM_GAP_INTERVAL
        number_of_gaps += 1
        return create_next_child if number_of_gaps > MAX_GAPS
      end #if
      intervals = @intervals.clone.push( interval)
      Node.make_new_node( parent = self, highest_note, number_of_gaps, intervals)
    end #def

    private
    def step_down_branch
      latest_interval = CANDIDATE_INTERVALS.first
      highest_note = @highest_note + latest_interval
      (@@processing_node = self; return) if check_stuff( highest_note)
      intervals = @intervals.clone.push( latest_interval)
# Assume the first is insufficiently large to be a gap.
      Node.make_new_node( parent = self, highest_note, @number_of_gaps, intervals)
    end #def

    def check_stuff( highest_note)
      highest_note > MAX_HIGHEST_NOTE ||
      @have_notes.include?( highest_note % Harmony::OCTAVE) ||
      @absolutes.include?( highest_note - Harmony::MINOR_NINTH)
    end #def

  end #class
#-----------------------------
  class Nodes
# A virtual tree, using depth-first traversal; only a single branch exists at any one time.
    def initialize( beginning)
      intervals = beginning.inject( nil) {|memo, e| memo.nil? ? [e] : memo.push( e - memo.last)}
      @first_leaf = Node.make_new_node( parent = nil, highest_note = beginning.last,
      number_of_gaps = 0, intervals)
    end #def

    def each
# Because of depth-first traversal, never need to access child nodes, here.
      node = @first_leaf
#     undef @first_leaf # Allow eventual garbage collection of first branch.
      until node.nil?
        yield node
        node = node.create_sibling
      end #until
    end #def

  end #class
end #module
#=============================
module Harmony2
#-----------------------------
  class Read_tree
@@count = 0
    def walk( beginnings)
     beginnings.each {|beginning| Tree::Nodes.new( beginning).each {|node| handle( node)}}
print '@@count '; p @@count
    end

    def handle( node)
@@count += 1
print 'node.dump '; p node.dump
    end
  end #class
end #module
#=============================
module Main
#-----------------------------
  class Run
    def initialize
#     Harmony::Chord_beginning.chord_class = Harmony::Chord
#     Harmony::Chord_beginning.chord_class = Harmony::Chord_accumulate
#      Harmony::Chord_beginning.chord_class = Harmony::Chord_print
#      Harmony::Chord_beginning_categories.new.handle
#      Harmony2::Read_tree.new.walk( Harmony::Chord_beginning_categories.new)
      Harmony2::Read_tree.new.walk( [[0]])
    end
  end #class
end #module
#=============================
Main::Run.new