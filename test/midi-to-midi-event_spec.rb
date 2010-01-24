require 'spec'
require 'miditomidievent'

# 63 Program 2:1 There shall be a program}, a Unix-like tool} to extract, from} MIDI, a stream of (intermediate-layer) events: ('mid2mev').
module MidiToMidiEvent
#-----------------------------
  describe "Unix-like tool, MidiToMidiEvent must correctly handle an input file which" do
    before( :each) do
      @nodes = [base = File.dirname( __FILE__),
               subdirectory = 'midi-to-midi-event']
    end
    it "is empty" do
      @nodes.push( file = 'empty.mid')
      file_name = File.expand_path( File.join( @nodes))
      MidiToMidiEvent.new( file_name).extract().should == ''
    end
    it "contains a single note, G2" do
      @nodes.push( file = 'single-note-G2.mid')
      file_name = File.expand_path( File.join( @nodes))
      MidiToMidiEvent.new( file_name).extract().should == '43'
    end
  end
end
