=begin
Composer sketch tool.
Author: Mark D. Blackwell.
Date started writing: March 21, 2009.
Date last modified: November 26, 2009.
Copyright (c) 2009 Mark D. Blackwell.

G B Eb(D) F# A C# F(E) Ab C E(Eb) (D-F): Bb
11-bit binary numbers are 2**11 = 2048 raw sequences.
require printer
require compositionfileio
Use special processing for gaps; keep them out of chord_word.
Use Enumerable.
=end
require 'invokeutilities'
require 'chordutilities'
require 'generatedprunedorderedpostordernarytree'
require 'generatechords'
require 'generatenotespace'
require 'harmonymidi'
module Invoke
#-----------------------------
  class SomeClass # TO DO: Move code from this into the Build class.
    def initialize( v)
      @variation = v.to_s
    end
    def save
      file_name = 'some-class-' + @variation + '.txt'
      contents = 'contents-' + @variation
      MyFile.open( file_name, 'w') {|file| file.write contents}
    end
  end
#-----------------------------
  class Build
    include InvokeUtilities
    include ChordUtilities

    def initialize( note_space_width)
      @logger = MyLogger.new( 'log/build.txt')
      @logger.debug 'in Invoke::Build#initialize'
      set_file_names( note_space_width)
      return if note_space_width <= 0
      @note_space = GenerateNoteSpace::NoteSpace.new( note_space_width)
      @most_significant_bit_value = @note_space.most_significant_bit_value
      build_fill_chords()
#      @fill_chords = []
      add_fill_chords_to_necklaces( @fill_chords)
      save_chords()
      save_necklaces()
    end #def

    def set_file_names( note_space_width)
      @chords_file_name    =    'chords-' + @note_space_width.to_s + '-0.txt'
      @necklaces_file_name = 'necklaces-' + @note_space_width.to_s + '-0.txt'
    end

    def load_it( note_space_width)
      set_file_names( note_space_width)
      load_chords()
      load_necklaces()
    end

    def load_chords
      f = File.new( @chords_file_name, 'r')
      @note_space.load_chords( f)
      f.close
    end

    def load_necklaces
      f = File.new( @necklaces_file_name, 'r')
      @note_space.load_necklaces( f)
      f.close
    end

    def select
#      @select_necklaces_indices = (0...@note_space.necklaces.length).to_a
#      @select_necklaces_indices = [] # Empty means, 'Use all the notes.'
      @select_necklaces_indices = [1] # Or 0,33,69,350,[0, 1, 69, 280],[5, 10, 11, 12, 13, 14]
    end

    def build_fill_chords
#@logger.debug 'in Invoke::Build#build_fill_chords'
#@logger.debug 'in Invoke::Build#build_fill_chords before GenerateChords::TreeDecorator.new'
      @tree_decorator = GenerateChords::TreeDecorator.new( @note_space, get_necklaces_out_notes())
      @tree = GeneratedPrunedOrderedPostOrderNaryTree::Tree.new( @tree_decorator,
      GenerateChords::LeafDecorator.initial())
      dump_fixed()
#@logger.debug 'in Invoke::Build#build_fill_chords before GenerateChords::Tree#walk'
      @fill_chords, @counts_dump = @tree.walk
#@logger.debug 'in Invoke::Build#build_fill_chords after GenerateChords::Tree#walk'
    end

    def get_necklaces_out_notes
      width = @note_space.width
      exclude = Array.new( width, @select_necklaces_indices.empty? ? false : true)
      @select_necklaces_indices.each do |i|
        word = @note_space.necklaces.at( i).word << Bit::BIT_WIDTH # Start before first.
        (1..12).each do |absolute|
          word >>= Bit::BIT_WIDTH
          exclude[ absolute % width] = false if Bit::BIT_VALUE_1 == word & Bit::SINGLE_BIT
        end #each bit
      end #each i
      exclude
    end

    def add_fill_chords_to_necklaces( fill_chords)
#@logger.debug 'in Invoke::Build#add_fill_chords_to_necklaces'
      fill_chords.each_with_index do |chords, fill_word|
        raise 'fill_word nil' if fill_word.nil?
        next if chords.nil?
        unnormalized_word = fill_word | @most_significant_bit_value
        normalized_word = normalize( unnormalized_word, @note_space.width)
        detected_necklace = @note_space.necklaces.word_to_necklace( normalized_word)
        detected_necklace.add_rooted_chord( unnormalized_word, chords) unless detected_necklace.nil?
      end #each_with_index chords, fill_word
    end #def

  end #class Build
end #module Invoke
