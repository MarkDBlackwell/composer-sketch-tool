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
    def initialize( file_name, method)
      @file = File.new( file_name, method)
    end

    def self.open( file_name, method)
      file = self.new( file_name, method)
      return file unless block_given?
      result = yield file # IO.open'ing a block didn't work!
      file.close
      result
    end #def

    def write( s)
      @file.write( s)
    end

    def print( s)
      @file.write( s)
    end

    def close
      @file.close()
    end
  end #class MyFile
#-----------------------------
  class MyLogger < Logger
    def initialize( file_name)
      super
    end
  end #class MyLogger
end #module InvokeUtilities
