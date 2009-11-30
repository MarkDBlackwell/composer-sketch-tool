require 'chordutilities'
require 'generatedprunedorderedpostordernarytree'
require 'generatechords'
require 'generatenotespace'
require 'harmonymidi'
module Invoke
#-----------------------------
  class Dump
    include ChordUtilities

    def initialize( note_space_width)
#p 'in Invoke::Dump#dump_initialize'
    end

    def dump_fixed
#p 'in Invoke::Dump#dump_fixed'
      print @tree_decorator.fixed
    end

    def run
#p 'in Invoke::Dump#run'
      necklaces_length = @note_space.necklaces.inject( 0) {|memo, e| memo += 1}
      print 'necklaces_length '; p necklaces_length
      count_root_numbers = @note_space.necklaces.inject( 0) {|memo, e| memo += e.root_numbers.length}
      print 'count_root_numbers '; p count_root_numbers
      count_root_words = @note_space.necklaces.inject( 0) {|memo, e| memo += e.root_words.length}
      print 'count_root_words '; p count_root_words
      count_roots = @note_space.necklaces.inject( 0) {|memo, e| memo += e.roots.compact.length}
      print 'count_roots '; p count_roots
      print @counts_dump
      print '@fill_chords.length '; p @fill_chords.length
    end #def dump

  end #class Dump
end #module Invoke
