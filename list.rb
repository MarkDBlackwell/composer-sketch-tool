require 'chordutilities'
require 'generatedprunedorderedpostordernarytree'
require 'generatechords'
require 'generatenotespace'
require 'harmonymidi'
module Invoke
#-----------------------------
  class List
    include ChordUtilities

    def initialize( note_space_width)
#p 'in Invoke::List#initialize'
      load_it( note_space_width)
    end

    def run
#p 'in Invoke::List#run'
      select()
    end

  end #class List
end #module Invoke
