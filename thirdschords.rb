=begin
Thirds Chords
Author: Mark D. Blackwell.
Date started writing: March 21, 2009.
Date last modified: March 22, 2009.
Copyright (c) 2009 Mark D Blackwell.

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
Are 2^11 = 2048 raw sequences.
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
Loop through 2^11 chords
Keep good ones; reject bad ones.

require necklacechords
require thirdschords
require printer
require compositionfileio
namespace thirdschords
Use special processing for gaps; keep them out of chord_word.
Use Enumerable.
a = new All_chords
a.each {|e| p e}
=end

class Third_chord_words
  def each
    (0..2^11).each do |word|
      yield word
    end
  end #def
end #class

class Third_chords
  STARTING_CHORD = [0]
  CW = new Third_chord_words

  def each
    CW.each do |word|
      thirds = word.unpack( 'b')
      note = STARTING_CHORD.last
      chord = STARTING_CHORD +
      thirds.collect do |e|
        case e
          |0| note += 4 # Major third.
          |1| note += 3 # Minor third.
        end #case
        note
      end
      yield chord
    end
  end #def
end #class

class Valid_length_third_chords
  CHORDS = chords

  def each
    new Third_chords.each do |chord|
      have = Array( 12, false)
      valid_length = 0 # Prepare in case all notes are invalid.
      chord.each_with_index do |note, i|
        if have.at( note % 12)
          valid_length = i
          break
        end #if
        have[ note % 12] = true
      end
      yield chord.truncate( valid_length)
    end
  end #def
end #class

class specific_length_chords
  def initialize( @length=l)
  end

  def each
    c = new Valid_length_third_chords
    a = c.find_all do |chord|
      chord.length == @length
    end
    a.each do |chord|
      yield chord
    end
  end #def
end #class

class Normalized_chord
  def initialize( chord)
    @value = '0' # Is stub.
  end

  def to_s
    @value
  end
end #class

class Chord
  def initialize( @value=v)
  end

  def to_s
    @value.collect do |note|
      note.to_s
    end.join( ' ')
  end #def

  def missing
    a = (0..12).to_a.not_in( @value)
    new Chord( a)
  end #def
end #class

class Note
  NOTE_NAMES = %w 'G Ab A Bb B C C# D Eb E F F#'

  def initialize( @value=v)
  end

  def to_s
    NOTE_NAMES.at( @value)
  end #def
end #class

class Print_some

  def to_s
    result = ''
    a = new Specific_length_chords( 12)
    a.each do |chord|
      result += new Normalized_chord( chord).to_s + ' ('
      result += chord.missing + ') '
      result += chord.reverse.to_s + "\n"
  end #def
end #class

p new Print_some.to_s