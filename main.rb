require 'chordutilities'
require 'generatechords'
require 'generatenotespace'
module Main
#-----------------------------
  class Program
    include ChordUtilities

    def initialize( note_space_length)
      @note_space = GenerateNoteSpace::NoteSpace.new( note_space_length)
      @most_significant_bit_value = @note_space.most_significant_bit_value
    end

    def run
#@note_space.necklaces.each {|necklace| print 'necklace.to_s ', necklace.to_s, "\n"}
#p 'in Main::Program#run before GenerateChords::Walker.new'
      @walker_new = GenerateChords::Walker.new( @note_space, GenerateChords::WalkerDecorator)
#p 'in Main::Program#run before GenerateChords::Walker#walk'
      @walker_fixed_dump = @walker_new.fixed
      dump_fixed()
      @fill_chords, @counts_dump = @walker_new.walk
#p 'in Main::Program#run after GenerateChords::Walker#walk'
      add_fill_chords_to_necklaces( @fill_chords)
      dump()
    end #def

    def add_fill_chords_to_necklaces( fill_chords)
#p 'in Main::Program#add_fill_chords_to_necklaces'
      fill_chords.each_with_index do |chord, fill_word|
        next if fill_word.nil?
        word = fill_word | @most_significant_bit_value
        detected = @note_space.necklaces.word_to_necklace( word)
#if detected.nil?
#print ' detected '; p detected
#else
#print ' detected.to_s '; p detected.to_s
#end
        detected.add_rooted_chord( word, chord) unless detected.nil?
      end #each_with_index chord, fill_word
    end #def

    def dump_fixed
      print @walker_fixed_dump
    end

    def dump
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
          @note_space.minor_ninth,
          @note_space.tritone,
          @note_space.octave_tritone,
          @note_space.major_second,
          @note_space.major_seventeenth,
          @note_space.fourth].collect {|interval| count_interval( chord.absolutes, interval).to_s}.join(' '),"]\n"
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