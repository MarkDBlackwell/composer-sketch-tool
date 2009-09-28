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
=end
#=============================
module Harmony
  NOTE_NAMES = %w{G Ab A Bb B C C# D Eb E F F#}
#-----------------------------
  class Chord
    include Enumerable
    def initialize( v)
      @value = v
    end

    def +( a)
      Chord.new( @value + a.value)
    end #def

    def at( i)
      @value.at( i)
    end

    def breadth
      @value.value.last
    end

    def each
      @value.each {|e| yield e}
    end

    def last
      @value.last
    end

    def length
      @value.length
    end

    def major_ninths_count
      count_pairings( 14)
    end

    def minor_ninths_count
      count_pairings( 13)
    end

    def missing
      one_octave = @value.collect {|e| e % NOTE_NAMES.length}
      Chord.new(( 0...NOTE_NAMES.length).to_a.reject {|e| one_octave.include?( e)})
    end

#    def take( a)
#      Chord.new( @value.slice( 0...a))
#    end

    def to_s
      @value.collect {|note| Note.new( note).to_s}.join( ' ')
    end

    def tritones_count
      count_pairings( 6)
    end

    def value
      @value
    end

    private
    def count_pairings( interval)
      matches=@value.collect do |e1|
        @value.find_all do |e2|
          e1 + interval == e2
        end #do
      end #do
      matches.flatten.length
    end #def
  end #class
#-----------------------------
  class Note
    def initialize( v)
      @value = v
    end

    def to_s
      NOTE_NAMES.at( @value % NOTE_NAMES.length)
    end
  end #class
#-----------------------------
#  class Note_from_name
#    def initialize( n)
#      @note_name = n
#    end

#    def number
#      NOTE_NAMES.index( @note_name)
#    end
#  end #class

end #module
#=============================
module Necklace_chords
#-----------------------------
  class Normalized_chord
    def initialize( chord)
      @value = '0' # Is stub.
    end

    def to_s
      @value
    end
  end #class
end #module
#=============================
module Chord_begin
#-----------------------------
  class Chord_beginnings
    CHORD_BEGINNINGS =[ # G, followed by:
#[ 0, 11, 13, 19], # F# Ab D - (Gap covers.)
[ 0, 11, 13, 15], # F# Ab Bb
#[ 0, 11], # F# - (Gap covers.)

[ 0, 10, 15], # F Bb
[ 0, 10, 13, 15], # F Ab Bb
#[ 0, 10], # F - (Gap covers.)

#[ 0, 9, 15], # E Bb - (Gap covers.)
[ 0, 9, 11, 19, 20, 22], # E F# D Eb F (U)
[ 0, 9, 11, 19, 20], # E F# D Eb (U)
#[ 0, 9, 11, 19], # E F# D (U) - (Gap covers.)
[ 0, 9, 11, 14, 16], # E F# A B (U)
#[ 0, 9, 11, 13, 19], # E F# Ab D - (Gap covers.)
[ 0, 9, 11, 13, 15], # E F# Ab Bb (U)
[ 0, 9, 11], # E F# (U)
#[ 0, 9], # E - (Gap covers.)

#[ 0, 8, 19], # Eb D - (Gap covers.)
#[ 0, 8, 15], # Eb Bb - (Gap covers.)
#[ 0, 8, 13, 19], # Eb Ab D - (Gap covers.)
[ 0, 8, 13, 15], # Eb Ab Bb
[ 0, 8, 13], # Eb Ab
#[ 0, 8, 11, 19], # Eb F# D (U) - (Gap covers.)
[ 0, 8, 11, 17, 19], # Eb F# C D (U)
#[ 0, 8, 11, 17], # Eb F# C (U) - (Gap covers.)
[ 0, 8, 11, 16], # Eb F# B (U)
#[ 0, 8, 11, 13, 19], # Eb F# Ab D - (Gap covers.)
[ 0, 8, 11, 13, 18], # Eb F# Ab C# (U)
[ 0, 8, 11, 13, 15], # Eb F# Ab Bb (U)
[ 0, 8, 11, 13], # Eb F# Ab
#[ 0, 8], # Eb (U) - (Gap covers.)

#[ 0, 7, 11, 17], # D F# C (U) - (Gap covers.)
[ 0, 7, 11, 13, 15], # D F# Ab Bb (U)
[ 0, 7, 11, 13], # D F# Ab (U)
[ 0, 7, 10, 16, 18], # D F B C# (U)
#[ 0, 7, 10, 16], # D F B (U) - (Gap covers.)
#[ 0, 7, 9, 11, 18], # D E F# C# (U) - (Gap covers.)
[ 0, 7, 9, 11, 15, 20, 22], # D E F# Bb Eb F (U)
[ 0, 7, 9, 11, 15, 20], # D E F# Bb Eb (U)
[ 0, 7, 9, 11, 14, 16], # D E F# A B (U)
[ 0, 7, 9, 11, 13, 15], # D E F# Ab Bb (U)
[ 0, 7, 9, 11, 13], # D E F# Ab (U)
[ 0, 7, 9, 11], # D E F# (U)
[ 0, 7, 9], # D E (U)
#[ 0, 7], # D (U) - (Gap covers.)

[ 0, 6, 10, 14, 15, 17], # C# F A Bb C (U)
[ 0, 6, 10, 14, 15], # C# F A Bb (U)
[ 0, 6, 9, 14, 16, 17], # C# E A B C (U)
[ 0, 6, 9, 14, 16], # C# E A B (U)
[ 0, 6, 9, 14], # C# E A (U)
[ 0, 6, 9, 11], # C# E F# (U)
[ 0, 6, 8, 10], # C# Eb F (U)
[ 0, 6, 8], # C# Eb (U)
#[ 0, 6], # C# (U) - (Gap covers.)

#[ 0, 5, 15], # C Bb - (Gap covers.)
#[ 0, 5, 13, 19], # C Ab D - (Gap covers.)
[ 0, 5, 13, 15], # C Ab Bb
#[ 0, 5, 13], # C Ab - (Gap covers.)
[ 0, 5, 11, 14, 16], # C F# A B (U)
#[ 0, 5, 11, 13, 19], # C F# Ab D - (Gap covers.)
[ 0, 5, 11, 13, 15], # C F# Ab Bb
[ 0, 5, 11, 13], # C F# Ab
#[ 0, 5, 11], # C F# (U) - (Gap covers.)
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
#[ 0, 5, 8, 16], # C Eb B (U) - (Gap covers.)
#[ 0, 5, 8, 15], # C Eb Bb - (Gap covers.)
#[ 0, 5, 8, 13, 19], # C Eb Ab D - (Gap covers.)
[ 0, 5, 8, 13, 15], # C Eb Ab Bb (U)
[ 0, 5, 8, 13], # C Eb Ab
[ 0, 5, 8, 10, 15], # C Eb F Bb (U)
[ 0, 5, 8, 10], # C Eb F (U)
#[ 0, 5, 7, 15], # C D Bb - (Gap covers.)
#[ 0, 5, 7, 13, 19], # C D Ab D
[ 0, 5, 7, 13, 15], # C D Ab Bb
#[ 0, 5, 7, 13], # C D Ab - (Gap covers.)
#[ 0, 5, 7, 11, 13, 19], # C D F# Ab D - (Gap covers.)
[ 0, 5, 7, 11, 13, 15], # C D F# Ab Bb
[ 0, 5, 7, 11, 13], # C D F# Ab
[ 0, 5, 7], # C D (U)
[ 0, 5], # C (U)

#[ 0, 4, 15], # B Bb - (Gap covers.)
[ 0, 4, 13, 15], # B Ab Bb (U)
[ 0, 4, 11, 14, 15], # B F# A Bb (U)
#[ 0, 4, 11, 13, 19], # B F# Ab D - (Gap covers.)
[ 0, 4, 11, 13, 15], # B F# Ab Bb (U)
[ 0, 4, 11, 13], # B F# Ab (U)
#[ 0, 4, 11], # B F# (U) - (Gap covers.)
[ 0, 4, 10, 13, 15], # B F Ab Bb (U)
#[ 0, 4, 10], # B F (U) - (Gap covers.)
#[ 0, 4, 9, 15], # B E Bb (U) - (Gap covers.)
#[ 0, 4, 9, 13, 19], # B E Ab D - (Gap covers.)
[ 0, 4, 9, 13, 15], # B E Ab Bb (U)
[ 0, 4, 9, 11, 13, 15], # B E F# Ab Bb (U)
[ 0, 4, 9, 11], # B E F# (U)
[ 0, 4, 9, 15], # B E (U)
#[ 0, 4, 8, 15], # B Eb Bb (U) - (Gap covers.)
#[ 0, 4, 8, 13, 19], # B Eb Ab D - (Gap covers.)
[ 0, 4, 8, 13, 15], # B Eb Ab Bb
[ 0, 4, 8, 13], # B Eb Ab
[ 0, 4, 8, 11, 13, 15], # B Eb F# Ab Bb (U)
[ 0, 4, 8, 11, 13], # B Eb F# Ab
[ 0, 4, 8, 10], # B Eb F (U)
#[ 0, 4, 7, 15], # B D Bb (U) - (Gap covers.)
#[ 0, 4, 7, 14], # B D A (U) - (Gap covers.)
[ 0, 4, 7, 13, 15, 17], # B D Ab Bb C (U)
[ 0, 4, 7, 13, 15], # B D Ab Bb (U)
#[ 0, 4, 7, 13], # B D Ab (U) - (Gap covers.)

#[ 0, 3, 13], # Bb Ab - (Gap covers.)
#[ 0, 3, 11], # Bb F# (U) - (Gap covers.)
[ 0, 3, 9, 11], # Bb E F# (U)
#[ 0, 3, 9], # Bb E (U) - (Gap covers.)
#[ 0, 3, 8, 13, 19], # Bb Eb Ab D - (Gap covers.)
[ 0, 3, 8, 13], # Bb Eb Ab
[ 0, 3, 8, 11, 13], # Bb Eb F# Ab
[ 0, 3, 8, 10], # Bb Eb F
[ 0, 3, 8], # Bb Eb
#[ 0, 3, 7, 13], # Bb D Ab - (Gap covers.)
[ 0, 3, 7, 11, 13], # Bb D F# Ab
[ 0, 3, 7, 9], # Bb D E
#[ 0, 3, 6, 14], # Bb C# A (U) - (Gap covers.)

#[ 0, 2, 11], # A F# - (Gap covers.)
[ 0, 2], # A

[ 0], # Just G (U)
#[ 0, 3], [ 0, 4], # Test of the 'do not need this chord' message functionality.
]
    def initialize
      @chord_beginnings = partly_generable? ? [] : CHORD_BEGINNINGS
    end

    def each
      @chord_beginnings.each {|e| yield e}
    end

    private
    def partly_generable?
      thirds =[ 3, 4]
      result = false
      CHORD_BEGINNINGS.each do |cb|
        (result = true; p 'Do not need this chord:', cb) if cb.length >= 2 and
                             thirds.include?( cb.last - cb[ cb.length - 2]) # Last interval.
      end #do
      result
    end #def
  end #class
end #module
#=============================
module Thirds_chords
#-----------------------------
  class All_thirds_chord_words
    include Enumerable
    def initialize( tl)
      @thirds_length = tl
    end

    def each
      (0...2 ** @thirds_length).to_a.each {|word| yield word}
    end
  end #class
#-----------------------------
  class All_thirds_chords
    include Enumerable
    def initialize( cb, tl)
      @chord_beginning = cb
      @thirds_length = tl
    end

    def each
      All_thirds_chord_words.new( @thirds_length).each do |word|
        thirds = (1..@thirds_length).collect {bit = word & 1; word >>= 1; bit}
        note = @chord_beginning.last
#        chord = @chord_beginning + thirds.collect do |e|
        chord = thirds.collect do |e|
          case e
            when 0; note += 4 # Major third.
            when 1; note += 3 # Minor third.
          end #case
          note
        end #do
        yield Harmony::Chord.new( chord)
      end #do
    end #def
  end #class
=begin
#-----------------------------
  class Specific_length_thirds_chords
    include Enumerable
    def initialize( v, cb, tl)
      @chord_beginning = cb
      @thirds_length = tl
      @valid_length_thirds_chords = v
    end

    def each
      found = Valid_length_thirds_chords.new( @chord_beginning, @thirds_length).find_all {|chord| chord.length == @chord_beginning.length + @thirds_length}
      found.each {|chord| yield Harmony::Chord.new( chord)}
    end
  end #class
=end
end #module
#=============================
module Gap
#-----------------------------
  class Gap_constellation_words
    include Enumerable
    def initialize( n)
      @number_of_bits = n
    end
    def each
      (2 ** @number_of_bits - 1).downto( 0) {|word| yield word}
    end
  end #class
#-----------------------------
  class Gap_constellation_good
    MAX_GAPS = 5
    EXCESSIVE_TOGETHER = 0b1111
    def initialize( a)
      @all_words = Gap_constellation_words.new( @array_length = a)
      @good_words = pick
    end
    def each
      @good_words.each {|e| yield e}
    end #def

    def length
      @good_words.length
    end

    private
    def pick
      @all_words.reject do |w|
        word = w
        count_gaps = 0
        word_bad = false
        @array_length.times do
          count_gaps += 1 if 0 == word & 1 # Least significant single bit.
          word_bad = true if count_gaps > MAX_GAPS ||
                             0 == word & EXCESSIVE_TOGETHER # Least significant several bits.
          break if word_bad
          word >>= 1
        end #do
        word_bad
      end #do
    end #def
  end #class
#-----------------------------
  class Gap_constellation_array
    def initialize( a)
      @good_words = Gap_constellation_good.new( @array_length = a)
    end

    def each
      @good_words.each {|word| yield bits_to_positions( word)}
    end #def

    def length
      @good_words.length
    end

    private
    def bits_to_positions( word)
      word <<= 1
      (0...@array_length).collect {|i| 1 == 1 & (word >>= 1) ? i : nil}.compact # Test each bit, least significant first.
    end #def
  end #class
end #module
#=============================
module Print_something
#-----------------------------
  class Print_line
    def initialize( ch, cb)
      @chord = ch
      @chord_beginning = cb
    end
    def to_s
        '[' + @chord_beginning.join(',') + ']' +
        ' - ' +
        '(' +
        'm9-' + @chord.minor_ninths_count.to_s +
        ' ' +
        'j9-' + @chord.major_ninths_count.to_s +
        ' ' +
        't-' + @chord.tritones_count.to_s +
        ' ' +
        's-' + @chord.breadth.to_s +
        ')' +
        ' - ' +
        '(' + @chord.missing.to_s + ')' +
        ' - ' +
        '(' + Necklace_chords::Normalized_chord.new( @chord).to_s + ')' +
        ' - ' +
        @chord.to_s +
        '' +
        "\n"
#      "\n" == s ? '' : s
    end
  end #class
=begin
#-----------------------------
  class Gapped_chords
    def initialize( cb, ep, tl)
      @chord_beginning = cb
      @existence_pattern = ep
      @thirds_length = tl
    end

    def each
      found.each do |full_chord|
#        chord = full_chord impressed with @existence_pattern
        chord = full_chord[ 0] # Assume at least have G.
        temp_chord = full_chord.slice( 1..-2)
# Maybe use Array#delete_if or Array#compact?.
        existence_positions = (0...@existence_pattern.length).collect {|i| @existence_pattern.at( i) ? i : nil}.compact


        chord = full_chord.first if full_chord.length >= 1
        chord += existence_positions.collect {|i| temp_chord.at( i)} if full_chord.length >= 3
        chord += full_chord.last if full_chord.length >= 2

#        if full_chord.length >= 3
      end #do
    end #def
  end #class
=end
#-----------------------------
  class Mathematical_format
# Here, do the chord-shortening loop.
    @@count = 0
    def initialize( cb, h, tc)
      @chord_beginning = cb
      @have = h
      @thirds_chord = tc
    end

    def print_me
      full_chord = @chord_beginning + @have.collect {|i| @thirds_chord.at( i)} + [@thirds_chord.last]
      print 'full_chord '; p full_chord
      chord = full_chord.slice( 0...(v = valid_length( full_chord)))
      print 'chord '; p chord
      print 'v '; p v
      print '@chord_beginning.length '; p @chord_beginning.length
#        @@count += 1
      (v - @chord_beginning.length).times do
#        print Print_line.new( chord, @chord_beginning).to_s
        @@count += 1
        print '@@count '; p @@count
        chord.pop
      end #do
    end #def

    def Mathematical_format.count
      @@count
    end

    private
    def valid_length( chord)
      octave = Harmony::NOTE_NAMES.length
      have = Array.new( octave, false)
      result = chord.length # Start by assuming the chord is all valid.
      chord.each_with_index do |note, i|
        if have.at( note % octave)
          result = i
          break
        end #if
        have[ note % octave] = true
      end #do
      result
    end #def
  end #class
end #module
#=============================
module Main
#-----------------------------
  class Main_do
    OCTAVE_LENGTH = 12
    def run
#      chord_begin = [ 0, 11, 13, 19]
      chord_begin = [ 0]
#      Chord_begin::Chord_beginnings.new.each do |chord_begin|
        print 'chord_begin '; p chord_begin
        max_thirds_length = OCTAVE_LENGTH - chord_begin.length
        all_thirds_chords = Thirds_chords::
        All_thirds_chords.new(              chord_begin, max_thirds_length)
        gap_patterns = Gap::Gap_constellation_array.new( max_thirds_length - 1) # The last place is not properly a gap.
        print 'gap_patterns.length '; p gap_patterns.length
#        thirds_chord = [0, 11, 13, 19]
        all_thirds_chords.each do |thirds_chord|
          print 'thirds_chord '; p thirds_chord
#          have = (0...max_thirds_length - 1).to_a
          have = (0..7).to_a
#          gap_patterns.each do |have|
            print 'have '; p have
            Print_something::Mathematical_format.new( chord_begin, have, thirds_chord).print_me
          end #do
#        end #do
#      end #do
      print 'Mathematical_format.count '; p Print_something::Mathematical_format.count
    end #def
  end #class
#-----------------------------
  Main_do.new.run
end #module