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
#-----------------------------
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

CANDIDATE_INTERVALS [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
MINIMUM_GAP_INTERVAL 9
MAX_HIGHEST_NOTE 24
MAX_GAPS 2
MAX_MINOR_SECOND 0
MAX_MINOR_NINTH 0
@@count 2324

CANDIDATE_INTERVALS [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
MINIMUM_GAP_INTERVAL 9
MAX_HIGHEST_NOTE 36
MAX_GAPS 2
MAX_MINOR_SECOND 0
MAX_MINOR_NINTH 0
@@count 58181

CANDIDATE_INTERVALS [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
MINIMUM_GAP_INTERVAL 9
MAX_HIGHEST_NOTE 48
MAX_GAPS 2
MAX_MINOR_SECOND 0
MAX_MINOR_NINTH 0
@@count 530446

CANDIDATE_INTERVALS [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
MINIMUM_GAP_INTERVAL 10
MAX_HIGHEST_NOTE 24
MAX_GAPS 2
MAX_MINOR_SECOND 0
MAX_MINOR_NINTH 0
@@count 2324

CANDIDATE_INTERVALS [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
MINIMUM_GAP_INTERVAL 10
MAX_HIGHEST_NOTE 36
MAX_GAPS 2
MAX_MINOR_SECOND 0
MAX_MINOR_NINTH 0
@@count 58425
=end
#=============================
module Harmony
  NOTE_NAMES = %w{G Ab A Bb B C C# D Eb E F F#}
  MINOR_SECOND = 1
  MAJOR_SECOND = 2
  MINOR_THIRD = 3
  MAJOR_THIRD = 4
  FOURTH = 5
  TRITONE = 6
  FIFTH = 7
  MINOR_SIXTH = 8
  MAJOR_SIXTH = 9
  MINOR_SEVENTH = 10
  MAJOR_SEVENTH = 11
  OCTAVE = NOTE_NAMES.length
  MINOR_NINTH = 13
  MAJOR_NINTH = 14
  MINOR_TENTH = 15
  MAJOR_TENTH = 16
  MINOR_SIXTEENTH = 25
  MAJOR_SIXTEENTH = 26
end #module Harmony
#=============================
module Bit
  BIT_WIDTH = 1
  SINGLE_BIT = 1
  BIT_STATES = 2
  BIT_VALUE_0 = 0
  BIT_VALUE_1 = 1
end #module Bit
#=========================
module Chord_utilities
  def absolutes_to_intervals( absolutes)
    previous  = absolutes.first
    intervals = absolutes.collect {|e| result = e - previous; previous = e; result}
  end

  def any_duplicates?( absolutes, length)
    have_note = Array.new( length).fill( false)
    absolutes.any? {|note| already = have_note.at( note % length)
                                     have_note[    note % length] = true; already}
  end #def

  def count_interval( absolutes, interval)
    count = 0
    (0...absolutes.length).each do |left_index|
      left = absolutes.at( left_index)
      (left_index + 1...absolutes.length).each do |right_index|
        difference = absolutes.at( right_index) - left
        count += 1 if difference == interval
        break if difference >= interval # Assume absolutes are sorted.
      end #each right_index
    end #each left_index
    count
  end #def

  def count_space( absolutes, interval)
    absolutes_to_intervals( absolutes).find_all {|e| e >= interval}.length
  end

  def missing( value, octave)
    to_one_octave = value.collect {|e| e % octave}
    Chord.new(( 0...octave).reject {|e| to_one_octave.include?( e)})
  end

  def normalize( word, width)
    most_significant_bit_value = Bit::BIT_VALUE_1 << (width - 1)
    (1..width).collect do
      least_significant_bit_was_set = Bit::BIT_VALUE_1 == word & Bit::SINGLE_BIT
      word >>= Bit::SINGLE_BIT
      word += most_significant_bit_value if least_significant_bit_was_set
      word
    end.max
  end #def

  def notes_per_octave( value, octave)
    value.length/(value.last.to_f/octave)
  end

  def out_of_order?( absolutes)
    absolutes.sort != absolutes
  end

  def pairings_count( value, interval)
    value.inject( 0) {|memo, low| memo + value.find_all {|high| low + interval == high}.length}
  end
end #module Chord_utilities
#=========================
module Branch_tree
=begin
Author: Mark D. Blackwell
Date created: April 24, 2009.
Date last changed: April 24, 2009.
A virtual tree, using depth-first traversal; only a single branch exists at any time.
=end
#-----------------------------
  class Walker
    def initialize
      Node.set_fixed()
      @tree = Tree.new
    end

    def walk
      @tree.each {|node| handle( node)}
      Node.print_counts()
    end

    def handle( node)
# Subclasses will do something, here.
      @@count += 1
    end

  end #class
#-----------------------------
  class Tree
# Subclasses should include, uncomment and perhaps change these next few lines:
#   def initialize
#     @first_leaf = Node.make_branch_and_return_leaf( parent = nil)
#   end
# (End of the lines that subclasses should include, uncomment and perhaps change.)

    def each
      node = @first_leaf
# Automatic, depth-first traversal obviates explicitly navigating downward to child nodes.
      (yield node; node = node.create_sibling()) until node.nil?
    end
  end #class
#-----------------------------
  class Node
#   private_class_method :new # Subclasses should uncomment this line.
   def initialize( p) # Subclasses might change these parameters.
         @parent = p
     step_out_branch_leftward()
# Initialize unhelpfully returns the *first* object made, by unwinding the stack, so instead use @@processing_node (see below).
   end #def

   def Node.make_branch_and_return_leaf(*args) # Subclasses might change these parameters.
     new( *args)
     @@processing_node # See comment under 'initialize', above.
   end #def

    public
    def Node.set_fixed
      @@count = 0
    end

    private
    def step_out_branch_leftward
# Subclasses should include, uncomment and perhaps change these next few lines:
#     until true # Subclasses change the conditions here, in order to extend the branch.
#       next if false # And change them here.
#       Node.make_branch_and_return_leaf( parent = self)
#       break
#     end #until
## Assume that before self (this node) was created, it was checked for anything bad that would end the branch.
#     @@processing_node = self if false # And change them here.
# (End of the lines that subclasses should include, uncomment and perhaps change.)
      @@processing_node
    end #def

    public
    def create_sibling
      return nil if @parent.nil?
      @parent.parent_create_next_child()
    end

# Subclasses should include, uncomment and perhaps change these next few lines:
#   protected
#   def parent_create_next_child
#     return create_sibling() if false # Subclasses change the conditions here, in order to swing the branch rightward.
#     return @@processing_node = self if false # And change them here.
#     return parent_create_next_child() if false # And change them here.
#     Node.make_branch_and_return_leaf( parent = self)
#   end
# (End of the lines that subclasses should include, uncomment and perhaps change.)

    public
    def Node.print_counts
      print '@@count '; p @@count
    end
  end #class
end #module Branch_tree
#=============================
module Generate_chords
#-----------------------------
  class Walker < Branch_tree::Walker
    def initialize( n)
          @note_space = n
# The first bit of this index always would have the same value, '1', for the note, G2, so drop that bit.
      @fill_chords = Array.new( Bit::BIT_STATES ** (@note_space.length - Bit::BIT_WIDTH)) {[]}
      Word. set_fixed( @note_space)
      Chord.set_fixed( @note_space)
      Node. set_fixed( @note_space)
      super()
    end

    def walk
      super
      @fill_chords
    end

    def handle( node)
      super
#print 'node.dump '; p node.dump
#p node.dump
      c = Chord.new( node.absolutes) # Add node to necklace root.
#print 'c.fill_word '; p c.fill_word
#print '@fill_chords[ c.fill_word] '; p @fill_chords[ c.fill_word]
      @fill_chords[ c.fill_word] = c unless @fill_chords.at( c.fill_word).any? {|e| e > c}
    end #def
  end #class
#-----------------------------
  class Tree < Branch_tree::Tree
    def initialize
#   # super # No such superclass method.
      @first_leaf = Node.make_branch_and_return_leaf( parent = nil, absolutes = [0]) # G2, by itself.
    end
  end #class
#-----------------------------
  class Node < Branch_tree::Node
    CANDIDATE_INTERVALS = ((Harmony::MAJOR_SECOND...Harmony::OCTAVE).to_a + [Harmony::MINOR_SIXTEENTH, Harmony::MAJOR_SIXTEENTH]).sort!; print 'CANDIDATE_INTERVALS '; p CANDIDATE_INTERVALS
    MINIMUM_GAP_INTERVAL = Harmony::TRITONE; print 'MINIMUM_GAP_INTERVAL '; p MINIMUM_GAP_INTERVAL
# The augmented chord filler takes 41 half-steps.
#   MAX_HIGHEST_NOTE = CANDIDATE_INTERVALS.last + Harmony::MAJOR_SEVENTH; print 'MAX_HIGHEST_NOTE '; p MAX_HIGHEST_NOTE
#   MAX_HIGHEST_NOTE = 41; print 'MAX_HIGHEST_NOTE '; p MAX_HIGHEST_NOTE
#   MAX_HIGHEST_NOTE = 44; print 'MAX_HIGHEST_NOTE '; p MAX_HIGHEST_NOTE
    MAX_HIGHEST_NOTE = 24; print 'MAX_HIGHEST_NOTE '; p MAX_HIGHEST_NOTE
    MAX_GAPS = 3; print 'MAX_GAPS '; p MAX_GAPS
    MAX_MINOR_SECOND = 0; print 'MAX_MINOR_SECOND '; p MAX_MINOR_SECOND
    MAX_MINOR_NINTH = 0; print 'MAX_MINOR_NINTH '; p MAX_MINOR_NINTH
    include Chord_utilities
    attr_reader :absolutes
    private_class_method :new

    def initialize( parent, a)
          @absolutes = a
# A value of CANDIDATE_INTERVALS.length has special meaning; see parent_create_next_child, below.
      @candidate_intervals_index = 0
#print 'self.dump '; p self.dump
      super( parent)
    end #def

    public
    def Node.set_fixed( n)
      @@note_space = n
      @@note_space_length = @@note_space.length
      super()
    end

    private
    def step_out_branch_leftward
      until @candidate_intervals_index >= CANDIDATE_INTERVALS.length
        absolutes = absolutes_for_child()
        @candidate_intervals_index += 1
        next if anything_bad?( absolutes)
        Node.make_branch_and_return_leaf( parent = self, absolutes)
        break
      end #until
# Assume that before this node (self) was created, it was checked for anything bad.
      @@processing_node = self if @candidate_intervals_index >= CANDIDATE_INTERVALS.length
      super
    end #def

    protected
    def parent_create_next_child
      return create_sibling() if @candidate_intervals_index > CANDIDATE_INTERVALS.length
# The special meaning of @candidate_intervals_index at CANDIDATE_INTERVALS.length is used here:
      (@candidate_intervals_index += 1; return @@processing_node = self) if CANDIDATE_INTERVALS.length == @candidate_intervals_index
      absolutes = absolutes_for_child()
      @candidate_intervals_index += 1
      return parent_create_next_child() if anything_bad?( absolutes)
      Node.make_branch_and_return_leaf( parent = self, absolutes)
#   # super # No such superclass method.
    end #def

    private
    def Node.print_counts
#print '@@count_have_minor_ninths '; p @@count_have_minor_ninths
    super
    end

    private
    def anything_bad?( absolutes)
      absolutes.last > MAX_HIGHEST_NOTE ||
          any_duplicates?( absolutes, @@note_space_length) ||
          count_space( absolutes, MINIMUM_GAP_INTERVAL) > MAX_GAPS ||
          count_interval( absolutes, @@note_space.minor_second) > MAX_MINOR_SECOND ||
          count_interval( absolutes, @@note_space.minor_ninth ) > MAX_MINOR_NINTH ||
          out_of_order?( absolutes)
    end #def

    private
    def absolutes_for_child
      @absolutes.clone.push( @absolutes.last + CANDIDATE_INTERVALS.at( @candidate_intervals_index))
    end

    public
    def dump
      'm9: ' + count_interval( @absolutes, @@note_space.minor_ninth).to_s + 
      ' ' +
      'm2: ' + count_interval( @absolutes, @@note_space.minor_second).to_s + 
      ' ' +
      'tt: ' + count_interval( @absolutes, @@note_space.tritone).to_s + 
      ' ' +
      'ng: ' + count_space(    @absolutes, MINIMUM_GAP_INTERVAL).to_s +
      ' ' +
      'j9: ' + count_interval( @absolutes, @@note_space.major_ninth).to_s + 
      ' ' +
      'hn: ' + (highest_note = @absolutes.last).to_s +
      ' ' +
      'i: [' + absolutes_to_intervals( @absolutes).join(',') + ']' +
      ''
    end

=begin
    def roots
      a = necklace <<= (Harmony::OCTAVE - 1)
      high_bit = Bit::SINGLE_BIT
      roots = (0...Harmony::OCTAVE).collect do |i|
        bit_set = high_bit == a & high_bit
        a = a ^ high_bit
        a <<= Bit::SINGLE_BIT
        a &= Bit::BIT_VALUE_1 if bit_set
        bit_set ? i : nil
      end #collect i
      roots
    end #def
=end

  end #class
#-----------------------------
  class Word
    attr_reader :value
    def initialize( absolutes)
      @@have_note.fill( false)
      absolutes.each {|e| @@have_note[ e % @@length] = true}
      @value = 0 # Start without notes.
      @@have_note.each {|e| @value <<= Bit::SINGLE_BIT; @value |= Bit::BIT_VALUE_1 if e}
    end

    def Word.set_fixed( note_space)
      @@length = note_space.length
      @@have_note = Array.new( @@length)
    end
  end #class
#-----------------------------
  class Chord
@@detail_count = 0

    def breadth
      @value.last
    end

    def handle( beginning) # The argument is used in subclasses.
@@detail_count += 1
    end

    def length
      @value.length
    end
    attr_reader :absolutes,
                :fill_word,
                :is_augmented_default,
                :is_hand_tuned,
                :word
    def initialize( a)
          @absolutes = a
      @word = Word.new( @absolutes).value
# The note, G2 is ever-present, so change the most-significant bit to zero.
      @fill_word = @word & @@mask
      @is_hand_tuned = false
      @is_augmented_default = false
    end #def

    def Chord.set_fixed( note_space)
      @@mask = (Bit::BIT_VALUE_1 << (note_space.length - Bit::BIT_WIDTH)) - 1
    end

    public
    def play
    end

    def <=>( other)
      1
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
      'm9-' + pairings_count( @value, MINOR_NINTH).to_s +
      ' ' +
      'j9-' + pairings_count( @value, MAJOR_NINTH).to_s +
      ' ' +
      't-' + pairings_count( @value, TRITONE).to_s +
      ' ' +
      'g-' + gaps_count.to_s +
      ' ' +
      's-' + breadth.to_s + # Span.
      ' ' +
      'd-' + ((100 * notes_per_octave( @value, OCTAVE)).round / 100.0).to_s + # Density
      ')' +
      ' - ' +
      '(' + missing( @value, OCTAVE).to_s + ')' +
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
end #module Generate_chords
#=============================
module Generate_note_space
#-----------------------------
  class Necklace_words
    include Chord_utilities
    include Enumerable
    def initialize( w)
          @width = w
      @good_words = (1..Bit::BIT_STATES ** @width).collect {|word| normalize( word, @width)}.sort!.uniq!
    end

    def each
      @good_words.each {|word| yield word}
    end
  end #class
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
      @@most_significant_bit_value = Bit::BIT_VALUE_1 << (@@width - 1)
    end

    def to_s
     '[' + (0...@@width).reject {|i| @roots.at( i).nil?}.join( ',') + ']'
    end

    def add_rooted_chord( word, chord)
      w = @word
      root = (0...@@width).detect do |i|
        maybe_root = w == word
        bit = 0 != w & @@most_significant_bit_value
        w &= ~@@most_significant_bit_value
        w <<= Bit::SINGLE_BIT
        w |= Bit::BIT_VALUE_1 if bit
        maybe_root
      end #detect i
      @roots[ root] = chord
    end #def

  end #class
#-----------------------------
  class Necklaces
    def initialize( note_space)
      Necklace.set_fixed( note_space)
      @necklaces = Necklace_words.new( note_space.length).collect {|word| Necklace.new( word)}
    end

    def each
      @necklaces.each {|necklace| yield necklace}
    end

    def word_to_necklace( word)
      @necklaces.detect {|e| e.word == word}
    end
  end #class
=begin
#-----------------------------
  class All_roots
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
  end #class
=end
#-----------------------------
  class Note_space
    attr_reader :length,
                :necklaces,
                :note_names,
    :minor_second, :major_second, :minor_third, :major_third, :fourth, :tritone, :fifth,
    :minor_sixth, :major_sixth, :minor_seventh, :major_seventh, :octave, :minor_ninth, :major_ninth,
    :minor_tenth, :major_tenth, :minor_sixteenth, :major_sixteenth

    def initialize
      @note_names = %w{G Ab A Bb B C C# D Eb E F F#}
      @length = @octave = @note_names.length
      @minor_second, @major_second = 1, 2
      @minor_third, @major_third = 3, 4
      @fourth, @tritone, @fifth = 5, 6, 7
      @minor_sixth, @major_sixth = 8, 9
      @minor_seventh, @major_seventh = 10, 11
      @minor_ninth, @major_ninth = 13, 14
      @minor_tenth, @major_tenth = 15, 16
      @minor_sixteenth, @major_sixteenth = 25, 26
      @necklaces = Necklaces.new( self)
    end
  end #class
end #module Generate_note_space
#=============================
module Main
#-----------------------------
  class Run
    def initialize
      @note_space = Generate_note_space::Note_space.new
      @most_significant_bit_value = Bit::BIT_VALUE_1 << (@note_space.length - 1)

#     @note_space.necklaces.each {|necklace| print necklace.to_s, "\n"}
      @fill_chords = Generate_chords::Walker.new( @note_space).walk
      add_fill_chords_to_necklaces( @fill_chords)
      dump()
    end #def

    def dump
      empty_ones = []
      sum = 0
      sum_length = 0
      @fill_chords.each_with_index do |e, i|
        empty_ones.push( i) if e.empty?
        sum += e.length
        thing = e.collect {|a| a.absolutes}
        sum_length += thing.length
       #print i, ' ', i.to_s( 2), ' '; p thing
        print i, ' ', thing.length, ' ', ( @most_significant_bit_value | i).to_s( 2), ":\n"; thing.each {|e| p e}
      end #each_with_index e, i
     #print 'empty_ones  '; p empty_ones
      @fill_chords.each_with_index do |e, i|
        next unless e.empty?
# Print i exploded to bits.
        print 'i ', i, ' '; p ( @most_significant_bit_value | i).to_s( 2)
      end #each_with_index e, i
      print 'empty_ones.length  '; p empty_ones.length
      print '@fill_chords.length '; p @fill_chords.length
      print 'sum_length '; p sum_length
      print 'sum_length.to_f/@fill_chords.length  '; p sum_length.to_f/@fill_chords.length
      print 'sum  '; p sum
    end #def

    def add_fill_chords_to_necklaces( fill_chords)
      fill_chords.each_with_index do |chord, fill_word|
        next if fill_word.nil?
        word = fill_word | @most_significant_bit_value
        detected = @note_space.necklaces.word_to_necklace( word)
print ' detected '; p detected
        detected.add_rooted_chord( word, chord) unless detected.nil?
      end #each_with_index chord, fill_word
    end #def

  end #class
end #module Main
#=============================
Main::Run.new