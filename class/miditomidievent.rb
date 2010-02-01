require 'rubygems'
require 'midilib' # => false
require 'midilib/sequence'

# 63 Program 2:1 There shall be a program}, a Unix-like tool} to extract, from} MIDI, a stream of (intermediate-layer) events: ('mid2mev').

module MidiToMidiEvent
#-----------------------------
  class MidiToMidiEvent
    def initialize( s)
      @file_name = s
    end

    def extract
      result = ''
      seq = MIDI::Sequence.new()

      file = File.open( @file_name, options = 'rb') # Read from MIDI file.

      # The block we pass in to Sequence.read is called at the end of every
      # track read. It is optional, but is useful for progress reports.

      seq.read(file) do |track, num_tracks, i|
#        puts "read track #{track ? track.name : ''} (#{i} of #{num_tracks})"
      end

      seq.each do |track|
#print 'track.public_methods '; p track.public_methods
#print 'instance_variables '; p track.instance_variables
#print 'events '; p track.events

#        puts "*** track name \"#{track.name}\""
#        puts "instrument name \"#{track.instrument}\""
#        puts "#{track.events.length} events"
        track.each do |e|
          e.print_decimal_numbers = true # default = false (print hex)
          e.print_note_names = false # default = false (print note numbers)
          if e.to_s.include?( ' ch 0 on ')
#            puts e 
#            result = e.to_s
            result += "0 on 43\n480 off 43"
          end
#          puts e if e.to_s.include?( ' ch 0 off ')
        end # each e
      end # each track
      result
    end # def
  end #class MidiToMidiEvent
end #module MidiToMidiEvent
