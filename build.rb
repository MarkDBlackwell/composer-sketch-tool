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
  class Build
    include InvokeUtilities
    include ChordUtilities

    def initialize( n)
      @note_space_width = n
      @logger = MyLogger.new( 'log/build.txt')
      @logger.debug 'in Invoke::Build#initialize'
      suffix = @note_space_width.to_s + '.txt'
      @file_name_chords    = 'marshal/chords-'    + suffix
      @file_name_necklaces = 'marshal/necklaces-' + suffix
      if @note_space_width >= 1
        @note_space = GenerateNoteSpace::NoteSpace.new( @note_space_width)
        @most_significant_bit_value = @note_space.most_significant_bit_value
        build_fill_chords()
#        @fill_chords = []
        add_fill_chords_to_necklaces( @fill_chords)
        save_chords()
        save_necklaces()
      end
    end #def

    def save_chords
      chords = 'contents-' + @note_space_width.to_s
      f = MyFile.new( @file_name_chords, 'w')
      f.print( chords)
      f.close
    end

    def save_necklaces
      necklaces = 'contents-' + @note_space_width.to_s
      f = MyFile.new( @file_name_necklaces, 'w')
      f.print( necklaces)
      f.close
#      f.print( YAML::dump( @note_space.necklaces)) # IO.open'ing a block didn't work! ???
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
