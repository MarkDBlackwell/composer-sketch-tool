require 'spec'
require 'miditobass'

# 63 Program 2:1 There shall be a program}, a Unix-like tool} to extract, from} MIDI, a stream of} bass note numbers: ('mid2bas').
module MidiToBass
#-----------------------------
  describe "Unix-like tool, MidiToBass must correctly handle an input file which" do
    before( :each) do
      @nodes = [base = File.dirname( __FILE__),
               subdirectory = 'midi-to-bass']
    end
    it "is empty" do
      @nodes.push( file = 'empty.mid')
      file_name = File.expand_path( File.join( @nodes))
      MidiToBass.new( file_name).extract().should == ''
    end
    it "contains a single note, G2" do
      @nodes.push( file = 'single-note-G2.mid')
      file_name = File.expand_path( File.join( @nodes))
      MidiToBass.new( file_name).extract().should == '43'
    end
  end
end
