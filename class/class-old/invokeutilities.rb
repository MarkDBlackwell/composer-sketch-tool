require 'logger'
module InvokeUtilities
    def load_all( note_space_width)
      set_file_names( note_space_width)
      load_chords()
      load_necklaces()
    end

    def load_chords
      f = File.new( @file_name_chords, 'r')
      @note_space.load_chords( f)
      f.close
    end

    def load_necklaces
      f = File.new( @file_name_necklaces, 'r')
      @note_space.load_necklaces( f)
      f.close
    end
#-----------------------------
  class MyFile
    def self.open( file_name, method, &block)
      File.  open( file_name, method, &block)
    end #def
  end #class MyFile
#-----------------------------
  class MyLogger < Logger
    def initialize( file_name)
      super
    end
  end #class MyLogger
end #module InvokeUtilities
