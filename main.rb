require 'chordutilities'
#require 'generatedprunedorderedpostordernarytree'
require 'generatechords'
require 'generatenotespace'
module Main
#-----------------------------
  class Program
    include ChordUtilities

    def initialize( note_space_width)
      @note_space = GenerateNoteSpace::NoteSpace.new( note_space_width)
      @most_significant_bit_value = @note_space.most_significant_bit_value
    end

    def run
#@note_space.necklaces.each {|necklace| print 'necklace.to_s ', necklace.to_s, "\n"}
#p 'in Main::Program#run before GenerateChords::Walker.new'
      @walker_decorator = GenerateChords::WalkerDecorator.new( @note_space)
      @walker = GeneratedPrunedOrderedPostOrderNaryTree::Walker.new( @walker_decorator,
          GenerateChords::TreeDecorator.new)
#p 'in Main::Program#run before GenerateChords::Walker#walk'
      dump_fixed()
      @fill_chords, @counts_dump = @walker.walk
#p 'in Main::Program#run after GenerateChords::Walker#walk'
      add_fill_chords_to_necklaces( @fill_chords)
      dump()
    end #def

    def add_fill_chords_to_necklaces( fill_chords)
#p 'in Main::Program#add_fill_chords_to_necklaces'
      fill_chords.each_with_index do |chord_array, fill_word|
        next if fill_word.nil?
        unnormalized_word = fill_word | @most_significant_bit_value
        detected = @note_space.necklaces.word_to_necklace( unnormalized_word)
#if detected.nil?
#print ' detected '; p detected
#else
#print ' detected.to_s '; p detected.to_s
#end
        detected.add_rooted_chord( unnormalized_word, chord_array) unless detected.nil?
      end #each_with_index chord_array, fill_word
    end #def

    def dump_fixed
      print @walker_decorator.fixed
    end

    def dump
# TO-DO: Print in (necklaces, roots) order.
# TO-DO: Count rooted chords in necklaces: should be 2048.
# E.g., @note_space.necklaces.each do |e|
      necklaces_length = @note_space.necklaces.inject( 0) {|memo, e| memo += 1}
print 'necklaces_length '; p necklaces_length
      count_root_numbers = @note_space.necklaces.inject( 0) {|memo, e| memo += e.root_numbers.length}
print 'count_root_numbers '; p count_root_numbers
      count_root_words = @note_space.necklaces.inject( 0) {|memo, e| memo += e.root_words.length}
print 'count_root_words '; p count_root_words
      count_roots = @note_space.necklaces.inject( 0) {|memo, e| memo += e.roots.compact.length}
print 'count_roots '; p count_roots
      @note_space.necklaces.each do |necklace|
print 'necklace.word.to_s( 2) '; p necklace.word.to_s( 2)
        necklace.root_words.each do |root_word|
print 'root_word.to_s( 2) '; p root_word.to_s( 2)
        end #each root_word
        necklace.roots.each do |chord_array|
          break if chord_array.nil?
          chord_array.each do |chord|
print 'chord.word.to_s( 2) '; p chord.word.to_s( 2)
          end #each chord
        end #each chord_array
      end #each necklace

      print @counts_dump
      empty_ones = []
      sum = 0
      sum_length = 0

      @fill_chords.each_with_index do |e, i|
        empty_ones.push( i) if e.empty?
        sum += e.length
        thing = e.collect {|a| a.absolutes}
        sum_length += thing.length
        next if thing.empty?
       #print i, ' ', i.to_s( 2), ' '; p thing
        print i, ' ', thing.length, ' ', (@most_significant_bit_value | i).to_s( 2), ":\n"
#       thing.each {|e| print e.inspect, }
        e.each do |chord|
          print chord.absolutes.inspect, '[m9 tr ot j2 j17 4 br]:[', [
          @note_space.octave_and_a_little,
          @note_space.half_octave,
          @note_space.octave_and_a_half,
          @note_space.a_little_and_a_little,
          @note_space.two_and_a_third_octaves,
          @note_space.third_octave_and_a_little].collect {|interval| count_interval( chord.absolutes, interval).to_s}.join(' '),"]\n"
        end #each chord
      end #each_with_index e, i

     #print 'empty_ones  '; p empty_ones
      print 'empty_ones.length  '; p empty_ones.length
      print '@fill_chords.length '; p @fill_chords.length
      print 'sum_length '; p sum_length
      print 'sum_length.to_f/@fill_chords.length  '; p sum_length.to_f/@fill_chords.length
      print 'sum  '; p sum
    end #def

  end #class Program
end #module Main