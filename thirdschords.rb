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
=end
#=============================
module Harmony
  NOTE_NAMES = %w{G Ab A Bb B C C# D Eb E F F#}
  NOTE_NAMES_LENGTH = NOTE_NAMES.length
#-----------------------------
  class Chord
    include Enumerable
    def initialize( v)
      @value = v
    end

    def +( s)
      @value.to_s + s
    end #def

    def each
      @value.each {|e| yield e}
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
      one_octave = @value.collect {|e| e % NOTE_NAMES_LENGTH}
      Chord.new(( 0...NOTE_NAMES_LENGTH).to_a.reject {|e| one_octave.include?( e)})
    end

    def reverse
      Chord.new( @value.reverse)
    end

    def to_s
      @value.collect {|note| Note.new( note).to_s}.join( ' ')
    end

    def tritones_count
      count_pairings( 6)
    end

    def truncate( a)
      Chord.new( @value.slice( 0...a))
    end

    private
    def count_pairings( interval)
      matches=@value.collect do |e1|
        @value.find_all do |e2|
          e1 + interval == e2
        end #do
      end #do
      matches.flatten.length
    end
  end #class
#-----------------------------
  class Note
    def initialize( v)
      @value = v
    end

    def to_s
      NOTE_NAMES.at( @value % NOTE_NAMES_LENGTH)
    end
  end #class
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
module Thirds_chords
  THIRDS_LENGTH = 11
  OCTAVE_LENGTH = THIRDS_LENGTH + 1
#-----------------------------
  class All_thirds_chord_words
    include Enumerable
    def each
      (0...2 ** THIRDS_LENGTH).to_a.each {|word| yield word}
    end
  end #class
#-----------------------------
  class All_thirds_chords
    include Enumerable
    STARTING_CHORD =[ 0]
    CW = All_thirds_chord_words.new
    def each
      CW.each do |word|
        a = word
        thirds = (1..THIRDS_LENGTH).collect {bit = a & 1; a >>= 1; bit}
        note = STARTING_CHORD.last
        chord = STARTING_CHORD + thirds.collect do |e|
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
#-----------------------------
  class Specific_length_thirds_chords
    include Enumerable
    def initialize( len)
      @length = len
    end

    def each
      found = Valid_length_thirds_chords.new.find_all {|chord| chord.length == @length}
      found.each {|chord| yield Harmony::Chord.new( chord)}
    end
  end #class
#-----------------------------
  class Valid_length_thirds_chords
    include Enumerable
    def initialize
      @value = All_thirds_chords.new.collect do |chord|
        have = Array.new( Harmony::NOTE_NAMES_LENGTH, false)
        valid_length = chord.length # Assume the whole chord is valid.
        chord.each_with_index do |note, i|
          if have.at( note % Harmony::NOTE_NAMES_LENGTH)
            valid_length = i
            break
          end #if
          have[ note % Harmony::NOTE_NAMES_LENGTH] = true
        end #do
        chord = chord.truncate( valid_length)
      end #do
    end #def

    def each
      @value.each {|e| yield e}
    end

    def to_s
      @value.collect {|e| e.to_s}
    end
  end #class
end #module
#=============================
module Main
#-----------------------------
  class Print_some
    def to_s
      Thirds_chords::Specific_length_thirds_chords.new( Thirds_chords::THIRDS_LENGTH + 1).collect do |chord|
        Necklace_chords::Normalized_chord.new( chord).to_s + ' - (' +
        chord.missing.to_s + ') - (m9-' +
        chord.minor_ninths_count.to_s + ' j9-' +
        chord.major_ninths_count.to_s + ' t-' +
        chord.tritones_count.to_s + ') - ' +
        chord.reverse.to_s
      end.join("\n")
    end
  end #class
#-----------------------------
  print Print_some.new.to_s
end #module