require 'logger'
module InvokeUtilities
    def save_chords
      f = File.new( @chords_file_name, 'w') # IO.open'ing a block didn't work!
      f.print( YAML::dump( @note_space.chords))
      f.close
    end

    def save_necklaces
      f = File.new( @necklaces_file_name, 'w') # IO.open'ing a block didn't work!
      f.print( YAML::dump( @note_space.necklaces))
      f.close
    end
#-----------------------------
  class MyFile
    def self.open( file_name, method)
      File.  open( file_name, method) {|file| yield file}
    end
  end #class MyFile
#-----------------------------
  class MyLogger < Logger
    def initialize( file_name)
      super
    end
  end #class MyLogger
end #module InvokeUtilities
