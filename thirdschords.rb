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

NOTE_NAMES = %w{G Ab A Bb B C C# D Eb E F F#}
#print 'NOTE_NAMES '; p NOTE_NAMES
#print "NOTE_NAMES.join( ' ') "; p NOTE_NAMES.join( ' ')

NOTE_NAMES_LENGTH = NOTE_NAMES.length
#print 'NOTE_NAMES_LENGTH '; p NOTE_NAMES_LENGTH

#THIRDS_LENGTH = 2
THIRDS_LENGTH = 11
print 'THIRDS_LENGTH '; p THIRDS_LENGTH
OCTAVE_LENGTH = THIRDS_LENGTH + 1

class All_third_chord_words
  include Enumerable
  def each
    (0...2 ** THIRDS_LENGTH).to_a.each do |word|
      yield word
    end #do
  end #def
end #class

class All_third_chords
  include Enumerable
  STARTING_CHORD =[ 0]
  CW = All_third_chord_words.new
# print 'CW '; p CW.collect {|e| e}

  def each
    CW.each do |word|
      a = word
      thirds = (1..THIRDS_LENGTH).collect do #11 bits.
#       print 'a '; p a
        bit = a & 1
        a >>= 1
        bit
      end #do
#     print 'thirds '; p thirds
      note = STARTING_CHORD.last
      chord = STARTING_CHORD +
      thirds.collect do |e|
        case e
        when 0
          note += 4 # Major third.
        when 1
          note += 3 # Minor third.
        end #case
        note
      end #do
#     print 'chord '; p chord
      yield Chord.new( chord)
    end #do
  end #def
end #class

class Chord
  include Enumerable
  def initialize( v)
    @value = v
  end #def

  def +( s)
    @value.to_s + s
  end #def

  def each
    @value.each {|e| yield e}
  end #def

  def length
    @value.length
  end #def

  def missing
    a = @value.collect do |e|
      e % NOTE_NAMES_LENGTH
    end #do
    b = (0...NOTE_NAMES_LENGTH).to_a.reject do |e|
      a.include?( e)
    end #do
    Chord.new( b)
  end #def

  def reverse
    Chord.new( @value.reverse)
  end #def

  def to_s
#   print " @value "; p @value
    a = @value.collect do |note|
      Note.new( note).to_s
    end #do
#   print "a "; p a
#   print "a.join "; p a.join
#   print "a.join( ' ') "; p a.join( ' ')
#   print "a.join( ' ').length "; p a.join( ' ').length
    a.join( ' ')
  end #def

  def truncate( a)
    b = @value.slice( 0...a)
#   print 'b=@value.slice( 0...a) '; p @value.slice( 0...a)
    c = Chord.new( b)
#   print 'c '; p c
    c
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

class Note
  def initialize( v)
    @value = v
  end

  def to_s
    NOTE_NAMES.at( @value % NOTE_NAMES_LENGTH)
  end #def
end #class

class Print_some
  def to_s
    result = ''
#   print ' Specific_length_chords.new( THIRDS_LENGTH + 1) '; p Specific_length_chords.new( THIRDS_LENGTH + 1)
    a = Specific_length_chords.new( THIRDS_LENGTH + 1)
    a.each do |chord|
      result += Normalized_chord.new( chord).to_s + ' - ('
      result += chord.missing.to_s + ') - '
      result += chord.reverse.to_s + "\n"
#     print 'chord '; p chord
    end #do
    result
  end #def
end #class

class Specific_length_chords
  def initialize( len)
    @length = len
  end

  def each
#   a = Valid_length_third_chords.new
#   a.each {|e| p e}
#   print 'Valid_length_third_chords.new.to_s '; p Valid_length_third_chords.new.to_s
    a = Valid_length_third_chords.new.find_all do |chord|
      chord.length == @length
    end #do
#   print 'a.length '; p a.length
    a.each do |chord|
      yield Chord.new( chord)
    end #do
  end #def
end #class

class Valid_length_third_chords
  include Enumerable

  def each
    get.each {|e| yield e}
  end #def

  def to_s
    a = get.collect do |e|
      e.to_s
    end #do
    a
  end #def

  private

  def get
#   count =0
    a = All_third_chords.new.collect do |chord|
      have = Array.new( NOTE_NAMES_LENGTH, false)
#     print ' have '; p have
      valid_length = chord.length # Start by assuming that all notes are valid.
      chord.each_with_index do |note, i|
#       print 'note ', note, ' i '; p i
#       count += 1
#       print ' have.at( note % NOTE_NAMES_LENGTH) '; p have.at( note % NOTE_NAMES_LENGTH)
        if have.at( note % NOTE_NAMES_LENGTH)
          valid_length = i
          break
        end #if
        have[ note % NOTE_NAMES_LENGTH] = true
      end #do
#     print 'valid_length '; p valid_length
      chord = chord.truncate( valid_length)
    end #do
#   print 'count '; p count
    a
  end #def
end #class

s = Print_some.new.to_s
print s