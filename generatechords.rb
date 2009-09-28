require 'chordutilities'
require 'generatedprunedorderedpostordernarytree'
module GenerateChords
#-----------------------------
  class Note
    def initialize( n, a)
      @note_space = n
      @absolute = a
    end
    def to_s
      @note_space.note_names.at( @absolute % @note_space.octave)
    end
  end #class Note
#-----------------------------
  class Word
    attr_reader :value
# Put G F# F E Eb D C# C B Bb A Ab into indices 0 11 10 9 8 7 6 5 4 3 2 1.
    def initialize( absolutes)
      @@have_note.fill( false)
      absolutes.each {|e| @@have_note[ e % @@width] = true}
      @value = 0 # Start without notes.
# Move G F# F E Eb D C# C B Bb A Ab into MSB to LSB, respectively.
      @@width.downto( 1) {|i| @value <<= Bit::BIT_WIDTH; @value |= Bit::BIT_VALUE_1 if @@have_note.at( i % @@width)}
    end

    def Word.set_fixed( note_space)
      @@width = note_space.width
      @@have_note = Array.new( @@width)
    end
  end #class Word
#-----------------------------
  class Chord
    attr_reader :absolutes,
                :fill_word,
                :is_augmented_default,
                :is_hand_tuned,
                :word
    include Enumerable
    include Comparable
    include ChordUtilities

    def initialize( a)
          @absolutes = a
      @word = Word.new( @absolutes).value
# The note, G2 is ever-present, so change the most-significant bit to zero.
      @fill_word = @word & @@mask
#print '@fill_word '; p @fill_word
      @is_hand_tuned = false
      @is_augmented_default = false
    end #def

    def Chord.set_fixed( n)
      @@note_space = n
      @@mask = @@note_space.most_significant_bit_value - 1
      @@detail_count = 0
    end

    def breadth
      @absolutes.last
    end

    def handle( beginning) # The argument is used in subclasses.
      @@detail_count += 1
    end

    def length
      @absolutes.length
    end

    public
    def play( transposition_distance)
    end

    def <=>( other)
      interest_hierarchy = [
      @@note_space.octave_and_a_little,
      @@note_space.half_octave,
      @@note_space.octave_and_a_half,
      @@note_space.a_little_and_a_little,
      @@note_space.two_and_a_third_octaves,
      @@note_space.third_octave_and_a_little,
      ]
      counts, other_counts = [@absolutes, other.absolutes].
      collect {|a| interest_hierarchy.collect {|e| count_interval( a, e)}}
# 'This one is less (desirable) than the other one' means more bad intervals, etc., so reverse the sign.
      interest_hierarchy_results = (0...interest_hierarchy.length).collect {|i| - (counts.at( i) <=> other_counts.at( i))}
# 'This one is less (desirable) than the other one' means greater breadth, so reverse the sign.
      interest_hierarchy_results.push( - (breadth <=> other.breadth))
#print '@fill_word.to_s( 2)', @fill_word.to_s( 2), 'other.fill_word.to_s( 2)', other.fill_word.to_s( 2),
#'[m9 tr ot j2 j17 4 br]:', interest_hierarchy_results.inspect, 'absolutes:', node_decorator.absolutes.inspect,
#'other.node_decorator.absolutes:', other.node_decorator.absolutes.inspect
      interest_hierarchy_results.each {|r| return r unless 0 == r}
      return 0
    end

    def to_s
      @absolutes.collect {|note| Note.new( @@note_space, note).to_s}.join( ' ')
    end

    def format_it( cb)
      @chord_beginning = cb
      to_s  +
      ' - ' +
      '['   + @chord_beginning.join(',') + ']' +
      ' - ' +
      '('   +
      'm9-' + count_interval( @absolutes, @@note_space.octave_and_a_little).to_s +
      ' '   +
      'j9-' + count_interval( @absolutes, @@note_space.major_ninth).to_s +
      ' '   +
      't-'  + count_interval( @absolutes, @@note_space.half_octave).    to_s +
      ' '   +
      'g-'  + gaps_count.to_s +
      ' '   +
      's-'  + breadth.   to_s + # Span.
      ' '   +
      'd-'  + ((100 * notes_per_octave( @absolutes, @@note_space.octave)).round /
                  100.0).to_s + # Density
      ')'   +
      ' - ' +
      '('   + missing(        @absolutes, @@note_space.octave).     to_s + ')' +
      ' - ' +
      '['   + Necklace::Normalized_chord.new( @chord).              to_s + ']' +
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
      Chord.new( @absolutes + a.value)
    end #def

    def at( i)
      @absolutes.at( i)
    end

    def each
      @absolutes.each {|e| yield e}
    end

    def last
      @absolutes.last
    end

    def value
      @absolutes
    end
=end
  end #class Chord
#-----------------------------
  class ChordPrint < Chord
    def handle( beginning); super
      print format_it( beginning)
    end
  end #class ChordPrint
#-----------------------------
  class ChordAccumulate < Chord
    def handle( beginning); super
      accumulate_unique( beginning)
    end
  end #class ChordAccumulate
#-----------------------------
  class NodeDecorator
    attr_reader :absolutes
    attr_accessor :candidate_intervals_index
    include ChordUtilities

    def initialize( a)
#p 'in GenerateChords::NodeDecorator#initialize'
          @absolutes = a
# A value of @@candidate_intervals.length has special meaning; see in_parent_create_next_child, below.
      @candidate_intervals_index = 0
    end

    public
    def NodeDecorator.set_fixed( n)
#p 'in GenerateChords::NodeDecorator.set_fixed'
          @@note_space = n
      @@node_class = GeneratedPrunedOrderedPostOrderNaryTree::Node
      @@candidate_intervals = ((@@note_space.a_little_and_a_little...  @@note_space.octave).to_a + [
      @@note_space.octave_and_a_little, @@note_space.major_ninth, 
# These next two are necessary for certain sparse necklaces.
      @@note_space.minor_sixteenth, @@note_space.major_sixteenth]).sort!
      @@note_space_width = @@note_space.width
      @@max_gaps = 3
      @@max_minor_secondths = 0
      @@minimum_gap_interval = @@note_space.half_octave
      @@max_minor_ninths = 1 # 0
      @@max_major_seconds_cluster = 2
      @@major_seconds_cluster = Array.new(
      @@max_major_seconds_cluster.succ, @@note_space.a_little_and_a_little)
# The lowest max_highest_note with more than one chord per necklace is 14.
# The lowest max_highest_note which fills all the chords is 35.
# The augmented chord filler takes 41 half-steps.
#     @@max_highest_note = @@candidate_intervals.last + @@note_space.major_seventh
      @@max_highest_note = 14 # 2 24 30 35 36 39 41 44 
      '@@candidate_intervals '       + @@candidate_intervals.      inspect + "\n" +
      '@@minimum_gap_interval '      + @@minimum_gap_interval.     inspect + "\n" +
      '@@max_gaps '                  + @@max_gaps.                 inspect + "\n" +
      '@@max_minor_secondths '       + @@max_minor_secondths.      inspect + "\n" +
      '@@max_minor_ninths '          + @@max_minor_ninths.         inspect + "\n" +
      '@@max_highest_note '          + @@max_highest_note.         inspect + "\n" +
      '@@max_major_seconds_cluster ' + @@max_major_seconds_cluster.inspect + "\n"
    end

    public
    def step_out_branch_leftward( node)
#p 'in GenerateChords::NodeDecorator#step_out_branch_leftward'
      until @candidate_intervals_index >= @@candidate_intervals.length
        absolutes = absolutes_for_child()
        @candidate_intervals_index += 1
        next if anything_bad?( absolutes)
        @@node_class.make_branch_and_return_leaf( parent = node, NodeDecorator.new( absolutes))
        break
      end #until
# Assume that before this node (node) was created, it was checked for anything bad.
      @@node_class.capture_leaf( node) if @candidate_intervals_index >= @@candidate_intervals.length
      @@node_class.leaf()
    end

    public
    def in_parent_create_next_child( parent)
#p 'in GenerateChords::NodeDecorator#in_parent_create_next_child'
# The special meaning of @node_decorator.candidate_intervals_index at 
# @@candidate_intervals.length is used here:
      if @candidate_intervals_index >= @@candidate_intervals.length
#p '@candidate_intervals_index >= @@candidate_intervals.length'
        @candidate_intervals_index += 1
        @@node_class.capture_leaf( parent)
      else
#p '@candidate_intervals_index < @@candidate_intervals.length'
        absolutes = absolutes_for_child()
        @candidate_intervals_index += 1
        if anything_bad?( absolutes)
          in_parent_create_next_child( parent)
        else
          @@node_class.make_branch_and_return_leaf( parent, NodeDecorator.new( absolutes))
        end
      end
    end #def

    private
    def anything_bad?( absolutes)
#p 'in GenerateChords::NodeDecorator#anything_bad?'
      absolutes.last > @@max_highest_note ||
      any_duplicates?( absolutes, @@note_space_width) ||
      count_space( absolutes, @@minimum_gap_interval) > @@max_gaps ||
      count_interval( absolutes, @@note_space.minor_second) > @@max_minor_secondths ||
      count_interval( absolutes, @@note_space.octave_and_a_little ) > @@max_minor_ninths ||
      major_seconds_cluster_too_long?( absolutes_to_intervals( absolutes)) ||
      out_of_order?( absolutes)
    end

    private
    def interval_position( intervals, question)
#p 'in GenerateChords::NodeDecorator#interval_position'
    end

    private
    def major_seconds_cluster_too_long?( intervals)
#p 'in GenerateChords::NodeDecorator#major_seconds_cluster_too_long?'
# After I install version 1.9 of Ruby, replace this with Enumerable's each_cons.
#   def each_cons( a, size)
#     (0..a.length - size).each {|i| yield a.slice(i, size)}
#   end
#     cluster = Array.new( size, @@note_space.a_little_and_a_little)
#     each_cons( intervals, size) {|a| (result = true; break) if cluster == a}
      size = @@major_seconds_cluster.length
      result = false
      (0..intervals.length - size).each {|i| (result = true; break) if intervals.slice( i, size) == @@major_seconds_cluster}
      result
    end

    private
    def absolutes_for_child
#p 'in GenerateChords::NodeDecorator#absolutes_for_child'
#print '@absolutes '; p @absolutes
      @absolutes.clone.push( @absolutes.last + @@candidate_intervals.at( @candidate_intervals_index))
    end

    private
    def dump
#p 'in GenerateChords::NodeDecorator#dump'
      'm9: ' + count_interval( @absolutes, @@note_space.octave_and_a_little).to_s + 
      ' ' +
      'm2: ' + count_interval( @absolutes, @@note_space.minor_second).to_s + 
      ' ' +
      'tt: ' + count_interval( @absolutes, @@note_space.half_octave).to_s + 
      ' ' +
      'ng: ' + count_space(    @absolutes, @@minimum_gap_interval).to_s +
      ' ' +
      'j9: ' + count_interval( @absolutes, @@note_space.major_ninth).to_s + 
      ' ' +
      'hn: ' + (highest_note = @absolutes.last).to_s +
      ' ' +
      'i: [' + absolutes_to_intervals( @absolutes).join(',') + ']'
    end

=begin
    private
    def roots
#p 'in GeneratedPrunedOrderedPostOrderNaryTree::Node#roots'
      a = necklace <<= (@@note_space.octave - 1)
      high_bit = Bit::SINGLE_BIT
      roots = (0...@@note_space.octave).collect do |i|
        bit_set = high_bit == a & high_bit
        a = a ^ high_bit
        a <<= Bit::SINGLE_BIT
        a &= Bit::BIT_VALUE_1 if bit_set
        bit_set ? i : nil
      end #collect i
      roots
    end #def
=end

  end #class NodeDecorator
#-----------------------------
  class TreeDecorator
    attr_reader :first_leaf
    def initialize
#p 'in GenerateChords::TreeDecorator#initialize'
      @first_leaf = GeneratedPrunedOrderedPostOrderNaryTree::Node.make_branch_and_return_leaf(
      parent = nil, NodeDecorator.new( absolutes = [0])) # G2, by itself.
    end
  end #class TreeDecorator
#-----------------------------
  class WalkerDecorator
    attr_reader :fill_chords,
                :fixed
    def initialize( n)
#p 'in GenerateChords::WalkerDecorator#initialize'
          @note_space = n
# The first bit of this index always would have the same value, '1', for the note, G2, so drop that bit.
      @fill_chords = Array.new( Bit::BIT_STATES ** (@note_space.width - Bit::BIT_WIDTH)) {[]}
      Word.      set_fixed( @note_space)
      Chord.     set_fixed( @note_space)
      @fixed = NodeDecorator.set_fixed( @note_space)
      GeneratedPrunedOrderedPostOrderNaryTree::Node.set_initial
    end

    def walk( counts)
#p 'in GenerateChords::WalkerDecorator#walk'
# Maybe use Return keyword.
      [@fill_chords, counts]
    end

    def handle( node)
#p 'in GenerateChords::WalkerDecorator#handle'
#print 'node.node_decorator.dump '; p node.node_decorator.dump
# Add node to necklace root.
      c = Chord.new( node.node_decorator.absolutes)
      these = @fill_chords.at( c.fill_word)
      if these.empty?
        these.push( c)
#print 'c.node_decorator.absolutes'; p c.node_decorator.absolutes
#print 'c.fill_word.to_s( 2)'; p c.fill_word.to_s( 2)
        return
      end #if
      bested = (0...these.length).find_all {|i| c > these.at( i)}
      unless bested.nil? || bested.empty?
        bested.each {|i| these.delete_at( i)} # Later, try changing this to assigning nil and compact!'ing.
        these.push( c)
#print 'c.node_decorator.absolutes'; p c.node_decorator.absolutes
#print 'c.fill_word.to_s( 2)'; p c.fill_word.to_s( 2)
      end #unless
    end #def

  end #class WalkerDecorator
end #module GenerateChords