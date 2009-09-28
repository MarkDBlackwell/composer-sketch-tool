require 'chordutilities'
#require 'generatedprunedorderedpostordernarytree'
require 'generatechords'
require 'generatenotespace'
require 'midi'
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
#p 'in Main::Program#run before GenerateChords::Tree.new'
      @tree_decorator = GenerateChords::TreeDecorator.new( @note_space)
      @tree = GeneratedPrunedOrderedPostOrderNaryTree::Tree.new( @tree_decorator,
      GenerateChords::LeafDecorator.initial())
#p 'in Main::Program#run before GenerateChords::Tree#walk'
      dump_fixed()
      @fill_chords, @counts_dump = @tree.walk
#p 'in Main::Program#run after GenerateChords::Tree#walk'
      add_fill_chords_to_necklaces( @fill_chords)
      dump()
      play()
    end #def

    def add_fill_chords_to_necklaces( fill_chords)
#p 'in Main::Program#add_fill_chords_to_necklaces'
      fill_chords.each_with_index do |chords, fill_word|
#       next if fill_word.nil?
        raise 'fill_word nil' if fill_word.nil?
        next if chords.nil?
        unnormalized_word = fill_word | @most_significant_bit_value
        normalized_word = normalize( unnormalized_word, @note_space.width)
        detected_necklace = @note_space.necklaces.word_to_necklace( normalized_word)
#if detected_necklace.nil?
#print ' detected_necklace '; p detected_necklace
#else
#print ' detected_necklace.to_s '; p detected_necklace.to_s
#end
        detected_necklace.add_rooted_chord( unnormalized_word, chords) unless detected_necklace.nil?
      end #each_with_index chords, fill_word
    end #def

    def dump_fixed
#p 'in Main::Program#dump_fixed'
      print @tree_decorator.fixed
    end

    def dump
#p 'in Main::Program#dump'
      necklaces_length = @note_space.necklaces.inject( 0) {|memo, e| memo += 1}
print 'necklaces_length '; p necklaces_length
      count_root_numbers = @note_space.necklaces.inject( 0) {|memo, e| memo += e.root_numbers.length}
print 'count_root_numbers '; p count_root_numbers
      count_root_words = @note_space.necklaces.inject( 0) {|memo, e| memo += e.root_words.length}
print 'count_root_words '; p count_root_words
      count_roots = @note_space.necklaces.inject( 0) {|memo, e| memo += e.roots.compact.length}
print 'count_roots '; p count_roots
      @note_space.necklaces.each do |necklace|
#      (0...0).each do |necklace|
#print 'necklace.word.to_s( 2) '; p necklace.word.to_s( 2)
#print 'necklace.word '; p necklace.word
        necklace.root_words.each do |root_word|
#        (0...0).each do |root_word|
#print 'root_word.to_s( 2) '; p root_word.to_s( 2)
#print 'root_word '; p root_word
        end #each root_word
      end #each necklace
#      @note_space.necklaces.each do |necklace|
      (0...0).each do |necklace|
        necklace.roots.each do |chord_array|
          break if chord_array.nil?
          chord_array.each do |array2|
            array2.each do |chord|
#print 'chord.absolutes '; p chord.absolutes
#print 'chord.inspect '; p chord.inspect
            end #each chord
          end #each array2
        end #each chord_array
      end #each necklace

      print @counts_dump
      empty_ones = []
      sum = 0
      sum_length = 0

      @fill_chords.each_with_index do |e, i|
#      (0...0).each_with_index do |e, i|
        empty_ones.push( i) if e.empty?
        sum += e.length
#print 'e.inspect '; p e.inspect
        thing = e.collect {|a| a.absolutes}
        sum_length += thing.length
        next if thing.empty?
#print i + 2048, ' ', i, ' ', i.to_s( 2), ' '; p thing
      end #each_with_index e, i

      @fill_chords.each_with_index do |e, i|
#      (0...0).each_with_index do |e, i|
#        thing = e.collect {|a| a.absolutes}
        thing = (0...0).collect {|a| a.absolutes}
        sum_length += thing.length
        next if thing.empty?
#print i + 2048, ' ', i, ' ', i.to_s( 2), ' '; p thing
#print i, ' ', thing.length, ' ', (@most_significant_bit_value | i).to_s( 2), ":\n"
#       thing.each {|e| print e.inspect, }
#        e.each do |chord|
        (0...0).each do |chord|
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
    end #def dump

    def play
#p 'in Main::Program#play'
# TO-DO: Count rooted chords in necklaces: should be 2048.
# E.g., @note_space.necklaces.each do |e|
      HarmonyMidi::Play.set_up()
p 'MSB to LSB, G F# F E Eb D C# C B Bb A Ab'
      @note_space.necklaces.each_with_index do |necklace, necklace_number|
#print 'necklace.word.to_s( 2) '; p necklace.word.to_s( 2)
#print 'necklace.word '; p necklace.word
#print 'necklace.root_words '; p necklace.root_words
#        necklace.root_words.each do |root_word|
        (0...0).each do |root_word|
#print 'root_word.to_s( 2) '; p root_word.to_s( 2)
        end #each root_word
        had_pause = false
        necklace.roots.each_with_index do |chords, i|
          next if chords.nil?
          array = chords.compact
#print 'array.inspect '; p array.inspect
          next if array.nil? || array.empty?
          (had_pause = true; HarmonyMidi::Play.handle_necklace( necklace, necklace_number)) unless had_pause
          array.each do |chord|
#print 'chord.absolutes '; p chord.absolutes
#print 'chord.inspect '; p chord.inspect
            HarmonyMidi::Play.handle_chord( chord.absolutes, necklace.root_numbers.at( i))
          end #each chord
        end #each_with_index chords, i
      end #each_with_index necklace, necklace_number
      HarmonyMidi::Play.tear_down()
    end

  end #class Program
end #module Main