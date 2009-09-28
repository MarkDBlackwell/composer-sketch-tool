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
      @velocity = 52
      beats_per_minute = 100
      @harmony.events << MIDI::Tempo.new(MIDI::Tempo.bpm_to_mpq(beats_per_minute))
      @harmony.events << MIDI::MetaEvent.new(MIDI::META_SEQ_NAME, 'Thirdschords')
      @harmony.add_notes([0], @velocity, 'half') # Ate the first one.
      @harmony.add_notes([], @velocity, 'eighth')
    end

    def Play.handle_chord
      absolutes = [ 0, 18]
      width = 12
      absolutes.unshift( -width)
      offset = 4 # Remove some boominess by setting the lowest root to B2.
      absolutes = absolutes.collect {|e| e + offset}
      @harmony.add_notes(absolutes, @velocity, 'half')
    end

    def Play.tear_down
      f = open('thirdsout.mid', 'w')
      @song.write( f)
      f.close
    end

  end #class Play
end #module HarmonyMidi

HarmonyMidi::Play.set_up()
HarmonyMidi::Play.handle_chord()
HarmonyMidi::Play.tear_down()
