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
#p 'in Main::Program#run'
#@note_space.necklaces.each {|necklace| print 'necklace.to_s ', necklace.to_s, "\n"}
      make_fill_chords()
      add_fill_chords_to_necklaces( @fill_chords)
      dump()
      play()
    end #def

    def make_fill_chords
      @counts_dump = ''
# The first bit of this index always would have the same value, '1', for the note, G2, so drop that bit.
      @fill_chords = Array.new( Bit::BIT_STATES ** (@note_space.width - Bit::BIT_WIDTH)) {[]}
      GenerateChords::Word.              set_fixed( @note_space)
      GenerateChords::Chord.             set_fixed( @note_space)
      thirds_chords = make_thirds_chords()
      thirds_chords.each do |e|
        c = GenerateChords::Chord.new( e)
        these = @fill_chords.at( c.fill_word)
        if these.empty?
          these.push( c)
#print 'c.fill_word.to_s( 2)'; p c.fill_word.to_s( 2)
          next
        end #if
        bested = (0...these.length).find_all {|i| c > these.at( i)}
        unless bested.nil? || bested.empty?
          bested.each {|i| these.delete_at( i)} # Later, try changing this to assigning nil and compact!'ing.
          these.push( c)
        end #unless
      end #do e
    end #def

    def make_thirds_chords
      width = @note_space.width
      full_length = 13 # G2 is added.
      words = (0...Bit::BIT_STATES ** width).to_a
      thirds_chords = []
      make_full_thirds_chords().each do |thirds_chord|
        pattern_chords = words.collect do |word|
          chord = thirds_chord.clone
          w = word << Bit::BIT_WIDTH # Start before first.
          (1...full_length).each do |i|
            w >>= Bit::BIT_WIDTH
            if Bit::BIT_VALUE_0 == (w & Bit::SINGLE_BIT)
#print 'w.to_s( 2) '; p w.to_s( 2)
              chord[ i] = nil
            end
          end #each i
          chord.compact!
#print 'chord '; p chord
          chord
        end #collect word
        thirds_chords.concat( pattern_chords)
      end #each thirds_chord
      thirds_chords
    end #def

    def make_full_thirds_chords
      width = 4
#     words = (0...Bit::BIT_STATES ** width).to_a
      words = [0, 1, 3, 7, 15]
      all_chords = []
      [[[4, 4, 3], [4, 3, 4]], [[4, 3, 4], [3, 4, 4]], [[4, 4, 3],[3, 4, 4]]].each do |pair|
        pattern, altered_pattern = pair
        chords = words.collect do |word|
          w = word << Bit::BIT_WIDTH # Start before first.
          intervals = (0...width).collect do
            w >>= Bit::BIT_WIDTH
            (1 == w & Bit::SINGLE_BIT) ? pattern : altered_pattern
          end #collect
          intervals_to_absolutes( intervals.reverse!.flatten!)
        end #collect word
        all_chords.concat( chords)
      end #each pair
      all_chords
    end

    def make_fill_chords_treewise
#p 'in Main::Program#make_fill_chords'
#p 'in Main::Program#make_fill_chords before GenerateChords::TreeDecorator.new'
      @tree_decorator = GenerateChords::TreeDecorator.new( @note_space)
      @tree = GeneratedPrunedOrderedPostOrderNaryTree::Tree.new( @tree_decorator,
      GenerateChords::LeafDecorator.initial())
      dump_fixed()
#p 'in Main::Program#make_fill_chords before GenerateChords::Tree#walk'
      @fill_chords, @counts_dump = @tree.walk
#p 'in Main::Program#run after GenerateChords::Tree#walk'
    end

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
p '111111111111, MSB to LSB, is G F# F E Eb D C# C B Bb A Ab'
      @note_space.necklaces.each_with_index do |necklace, necklace_number_off|
        necklace_number = necklace_number_off.succ
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
          (had_pause = true; HarmonyMidi::Play.handle_necklace( necklace, necklace_number, '')) unless had_pause
          array.each do |chord|
#print 'chord.absolutes '; p chord.absolutes
#print 'chord.inspect '; p chord.inspect
            HarmonyMidi::Play.handle_chord( chord.absolutes, necklace.root_numbers.at( i), '')
          end #each chord
        end #each_with_index chords, i
      end #each_with_index necklace, necklace_number
      HarmonyMidi::Play.tear_down()
    end

  end #class Program
end #module Main