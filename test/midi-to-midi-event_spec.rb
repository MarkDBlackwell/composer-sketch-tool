require 'spec'
require 'miditomidievent'

# 63 Program 2:1 There shall be a program}, a Unix-like tool} to extract, from} MIDI, a stream of (intermediate-layer) events: ('mid2mev').

module MidiToMidiEvent
#-----------------------------
  describe "Unix-like tool, MidiToMidiEvent must correctly handle an input file which" do
    def full( file_name)
      a = [ File.dirname( __FILE__), 'midi-to-midi-event', file_name]
      File.expand_path( File.join( a))
    end
    def extract( file_name)
      tool = MidiToMidiEvent.new( full( file_name))
      tool.extract()
    end
    def events( a)
      a.join("\n")
    end
    it "is empty" do
      extract( 'empty.mid').should == ''
    end
    it "contains a single note, G2" do
      extract( 'single-note-G2.mid').should == events([ '0 on 43', '480 off 43'])
    end
  end
end
