require 'rubygems'
require 'midilib'                                   # => false
#=========================
module HarmonyMidi
  TRACK_0 = 0
  GM_PATCH_NAME_ACOUSTIC_GRAND_PIANO = 0
  PITCH_G2 = 43
#-----------------------------
  class TimedTrack < MIDI::Track
# Borrowed from _.
    @@channel_counter=0

    def initialize(number, song)
      super(number)
      @sequence = song
      @time = 0
      @channel = @@channel_counter
      @@channel_counter += 1
    end

# Tell this track's channel to use the given instrument, and
# also set the track's instrument display name.
    def instrument=(instrument)
      @events << MIDI::ProgramChange.new(@channel, instrument)
      super(MIDI::GM_PATCH_NAMES[instrument])
    end

# Add one or more notes to sound simultaneously. Increments the per-track
# timer so that subsequent notes will sound after this one finishes.
    def add_notes(offsets, velocity=127, duration='quarter')
      offsets = [offsets] unless offsets.respond_to? :each
      offsets.each do |offset|
        event(MIDI::NoteOnEvent.new(@channel, PITCH_G2 + offset, velocity))
      end
      @time += @sequence.note_to_delta(duration)
      offsets.each do |offset|
        event(MIDI::NoteOffEvent.new(@channel, PITCH_G2 + offset, velocity))
      end
      recalc_delta_from_times
    end

    private
    def event(event)
      @events << event
     event.time_from_start = @time
    end
end #class TimedTrack
#-----------------------------
  class Play
    def Play.set_up
      @song = MIDI::Sequence.new
      @harmony = TimedTrack.new( TRACK_0, @song)
      @song.tracks << ( @harmony)
      @harmony.instrument = GM_PATCH_NAME_ACOUSTIC_GRAND_PIANO
#      @velocity = 127
#      @velocity = 63
      @velocity = 52
#      @velocity = 42
      beats_per_minute = 100
      correcting_factor = # By observation in RealPlayer.
      ((35 * 60) + 37.0) / ((42 * 60) + 42.0)
      seconds_per_beat = (60.0/beats_per_minute) * correcting_factor
      @harmony.events << MIDI::Tempo.new(MIDI::Tempo.bpm_to_mpq(beats_per_minute))
      @harmony.events << MIDI::MetaEvent.new(MIDI::META_SEQ_NAME, 'Thirdschords')
      @clock = 0.0
      @clock_half = 2.0 * seconds_per_beat
      @clock_eighth = seconds_per_beat / 2.0
      @harmony.add_notes([0], @velocity, 'half') # Ate the first one.
      @harmony.add_notes([], @velocity, 'eighth')
      @clock += 1.0 # By observation in RealPlayer.
    end

    def Play.handle_necklace( necklace, necklace_number)
     s = necklace.missing
     s = 'none' if s.empty?
print "\n#{necklace_number}: #{necklace.word.to_s( Bit::BINARY)} - #{necklace.expansion} not #{s} #{necklace.note_names}\n"
#      @harmony.events << MIDI::MetaEvent.new( MIDI::META_SEQ_NAME,
#                                    'A-random-Ruby-composition')
#                                    'necklace ' +
#                                     '')
# necklace.word.to_s( Bit::BINARY))
      @harmony.add_notes([], @velocity, 'eighth')
      @clock += @clock_eighth
    end

    def Play.handle_chord( note_space, absolutes, root_number, chord_name, transposition)
      width = note_space.width
      names = note_space.note_names
      notes = absolutes.collect {|e| names.at( e % width)}.join(' ')
#print "#{Play.clock_string()} #{root_number}-#{chord_name} #{absolutes.inspect} #{notes}\n"
print "#{Play.clock_string()} #{root_number}-#{chord_name} #{absolutes} #{notes}\n"
      absolutes.unshift( -width) if absolutes.length >= 2 && absolutes.at( 1) <= (width.to_f / 3.0).ceil
      offset = (transposition % width) + 4 # Remove some boominess by setting the lowest root to B2.
      absolutes = absolutes.collect {|e| e + offset}
      @harmony.add_notes(absolutes, @velocity, 'half')
      @clock += @clock_half
    end

    def Play.tear_down
      f = open('thirdsout.mid', 'w')
      @song.write( f)
      f.close
    end

    def Play.clock_string
      minutes = (@clock / 60.0).floor
      seconds = (@clock - (minutes * 60.0)).floor
      [minutes, seconds].collect {|e| (e >= 10 ? '' : '0') + e.to_s}.join( ':')
    end
  end #class Play
end #module HarmonyMidi
