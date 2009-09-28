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
chord_begin [0]
diff 2931732
gap_patterns.length 198
chord_begin [0, 5]
diff 520313
gap_patterns.length 107
chord_begin [0, 10, 15]
diff 118281
gap_patterns.length 56
chord_begin [0, 11, 13, 15]
diff 27448
gap_patterns.length 29
chord_begin [0, 9, 11, 19, 20]
diff 2770
gap_patterns.length 15
chord_begin [0, 9, 11, 19, 20, 22]
diff 1364
gap_patterns.length 8
chord_begin [0, 7, 9, 11, 15, 20, 22]
diff 316
Bottom.count 3602224
=end
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

#[ 0, 3, 7, 13], # Bb D Ab - (Gap covers.)
 [ 0, 3, 7, 11, 13], # Bb D F# Ab
 [ 0, 3, 7, 9], # Bb D E
#[ 0, 3, 6, 14], # Bb C# A (U) - (Gap covers.)
#-----2------------------------A
#[ 0, 2, 11], # A F# - (Gap covers.)
 [ 0, 2], # A

 [ 0], # Just G (U)
#[ 0, 3], [ 0, 4], # Test of the 'do not need this chord' message functionality.
]
#-----------------------------
  class Chord
    def initialize( v)
      @value = v
    end

    def breadth
      @value.last
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

    def to_s
      @value.collect {|note| Note.new( note).to_s}.join( ' ')
    end

    def pairings_count( interval)
      @value.inject( 0) {|memo, low| memo + @value.find_all {|high| low + interval == high}.length}
    end
=begin
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
  class Chord_beginnings
    include Enumerable
    def initialize
      @chord_beginnings = partly_generable? ? [] : BEGINNINGS
    end

    def each
      @chord_beginnings.each {|e| yield e}
    end

    private
    def partly_generable?
      result = false
      thirds =[ MINOR_THIRD, MAJOR_THIRD]
      BEGINNINGS.each do |cb|
        (result = true; p 'Do not need this chord:', cb) if cb.length >= 2 and
          thirds.include?( last_interval = cb.last - cb[    cb.length -  2])
      end
      result
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
module Thirds
#-----------------------------
  class All_chords
    SINGLE_BIT = 1
    BIT_STATES = 2
    BIT_VALUE_0 = 0
    BIT_VALUE_1 = 1

    include Enumerable
    def initialize( tl)
       @thirds_length = tl
    end

    def each_index
      (0...BIT_STATES ** @thirds_length).each {|i| yield i}
    end

#   private
    def each
      (0...BIT_STATES ** @thirds_length).each do |word|
        thirds = (0...@thirds_length).collect {bit_value = word & SINGLE_BIT; word >>= SINGLE_BIT; bit_value}
        note = 0
        relative_chord = thirds.collect do |third|
          case third
            when BIT_VALUE_0; note += Harmony::MAJOR_THIRD
            when BIT_VALUE_1; note += Harmony::MINOR_THIRD
          end #case
          note
        end #do third
        yield relative_chord
      end #do word
    end #def

  end #class
end #module
#=============================
module Gap
  SINGLE_BIT = 1
  BIT_STATES = 2
  BIT_VALUE_0 = 0
  BIT_VALUE_1 = 1
#-----------------------------
  class Constellation_words
    include Enumerable
    def initialize( n)
      @number_of_bits = n
    end
    def each
      (BIT_STATES ** @number_of_bits - 1).downto( 0) {|word| yield word}
    end
  end #class
#-----------------------------
  class Constellations
    MAX_GAPS = 5
    EXCESSIVE_TOGETHER = 0b1111

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
      Constellation_words.new( @width).reject do |word|
        count_gaps = 0
        word_bad = false
        @width.times do
          count_gaps += 1 if BIT_VALUE_0 == word & SINGLE_BIT # Least significant.
          word_bad = true if count_gaps > MAX_GAPS ||
                             0 == word & EXCESSIVE_TOGETHER # Least significant several bits.
          break if word_bad
          word >>= SINGLE_BIT
        end #do times
        word_bad
      end #do word
    end #def
  end #class
#-----------------------------
  class Constellation_positions
    include Enumerable
    def initialize( g)
      @good_words = g
    end

    def each
      @good_words.each {|word| yield bits_to_positions( word)}
    end

    def each_index
      @good_words.length.times {|i| yield i}
    end

    def length
      @good_words.length
    end

    private
    def bits_to_positions( word)
      word <<= SINGLE_BIT
      (0...@good_words.width).collect {|i| BIT_VALUE_1 == SINGLE_BIT & (word >>= SINGLE_BIT) ? i : nil}.compact # Test least significant first.
    end

  end #class
end #module
#=============================
module Print_something
#-----------------------------
  class Print_line
    def initialize( cb, ch)
      @chord_beginning = cb
      @chord = ch
    end
    def to_s
      '[' + @chord_beginning.join(',') + ']' +
      ' - ' +
      '(' +
      'm9-' + @chord.pairings_count( Harmony::MINOR_NINTH).to_s +
      ' ' +
      'j9-' + @chord.pairings_count( Harmony::MAJOR_NINTH).to_s +
      ' ' +
      't-' + @chord.pairings_count( Harmony::TRITONE).to_s +
      ' ' +
      'g-' + @chord.gaps_count.to_s +
      ' ' +
      's-' + @chord.breadth.to_s + # Span.
      ' ' +
      'd-' + ((100 * @chord.notes_per_octave).round / 100.0).to_s + # Density
      ')' +
      ' - ' +
      '(' + @chord.missing.to_s + ')' +
      ' - ' +
      '[' + Necklace::Normalized_chord.new( @chord).to_s + ']' +
      ' - ' +
      @chord.to_s +
      "\n"
    end
    def Print_line.heading
      "\n" +
      '[' + 'begin' + ']' +
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
      ' - ' +
      'chord' +
      "\n"
    end
  end #class
end #module
#=============================
module Math_format
#-----------------------------
  class Bottom
    @@count = 0

    def initialize( cb, re)
      @chord_beginning = cb
      @relative_extension = re
      @chord_beginning_last =
      @chord_beginning.last
      @chord_beginning_have = Array.new( Harmony::OCTAVE, false) # Start by assuming that @chord_beginning has no notes.
      @chord_beginning.each {|note| @chord_beginning_have[ note % Harmony::OCTAVE] = true}
    end

    def print_all_lengths
# Here, do the loop to check all shortenings of the chord.
#     print "Math_format::Bottom#print_some:\n"
#     print '@chord_beginning.length '; p @chord_beginning.length
# Assume extension is internally valid (has no note repetitions).
      extension = @relative_extension.collect {|relative_note| relative_note + @chord_beginning_last}
      chord = @chord_beginning.clone
      (0...extension.length).each do |i|
        break if @chord_beginning_have.at( extension.at( i) % Harmony::OCTAVE) # Have this note.
        chord.push( extension.at( i))
#       print 'chord '; p chord
#       print 'chord.length '; p chord.length
        print Print_something::Print_line.new( @chord_beginning, Harmony::Chord.new( chord)).to_s
        @@count += 1
#       print '@@count '; p @@count
      end #do i
#     print '@@count '; p @@count
    end #def

    def Bottom.count
      @@count
    end
  end #class
#-----------------------------
  class Top
    def sort_beginnings_by_length
      b = Harmony::Chord_beginnings.new
      lengths = [] if (lengths = b.collect {|e| e.length}.sort!.uniq!).nil?
      sorted_beginnings = Array.new( lengths.length) {[]}
      b.each {|e| sorted_beginnings[ lengths.index( e.length)].concat( [e])}
#     print 'sorted_beginnings '; p sorted_beginnings
      print 'sorted_beginnings.collect {|e| e.length} '
      p      sorted_beginnings.collect {|e| e.length}
      print Print_something::Print_line.heading
      [sorted_beginnings, lengths]
    end #def

    def run
#     print "Main::Top#run:\n"
      sorted_beginnings, lengths = sort_beginnings_by_length
      diff = 0
      begin_length_index = 6
#     (6...lengths.length).each do |begin_length_index|
#     lengths.each_index do |begin_length_index|
        max_thirds_length = Harmony::OCTAVE - lengths.at( begin_length_index)
        gap_patterns = Gap::Constellation_positions.new( 
                       Gap::Constellations.new( max_thirds_length - 1)) # The last place is not properly a gap.
        print 'gap_patterns.length '; p gap_patterns.length
        thirds_chords = Thirds::All_chords.new( max_thirds_length)

        extensions = intersect( thirds_chords, gap_patterns)
#       print 'extensions '; p extensions

#       sorted_beginnings.at( begin_length_index).each do |chord_begin|
        [sorted_beginnings.at( begin_length_index).first].each do |chord_begin|
          print 'chord_begin '; p chord_begin
          extensions.each do |extension|
#           print 'extension '; p extension
            Math_format::Bottom.new( chord_begin, extension).print_all_lengths
#           print "Main::Top#run:\n"
          end #do extension
        end #do chord_begin
        diff = Math_format::Bottom.count - diff
        print 'diff '; p diff
        diff = Math_format::Bottom.count
#     end #do begin_length_index
      print 'Bottom.count '; p Math_format::Bottom.count
    end #def

    private
    def intersect( thirds_chords, gap_patterns)
      result = []
      thirds_chords.each do |thirds_chord|
#       print 'thirds_chord '; p thirds_chord
#       print 'thirds_chord.length '; p thirds_chord.length
#       have = (0...max_thirds_length - 1).to_a
        gap_patterns.each do |have|
#         print 'have '; p have
          extension = have.collect {|i| thirds_chord.at( i)}.push( thirds_chord.last)
          extension.slice!( valid_length( extension)..-1)
          result.push( extension)
        end #do have
      end #do thirds_chord
      result
    end #def

    def valid_length( chord)
      have = Array.new( Harmony::OCTAVE, false)
      result = chord.length # Start by assuming the chord is all valid.
      chord.each_with_index do |note, i|
        if have.at( note % Harmony::OCTAVE)
          result = i
          break
        end #if
        have[ note % Harmony::OCTAVE] = true
      end #do
      result
    end #def
  end #class
end #module
#=============================
module Main
#-----------------------------
  Math_format::Top.new.run
end #module