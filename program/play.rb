require 'chordutilities'
require 'generatedprunedorderedpostordernarytree'
require 'generatechords'
require 'generatenotespace'
require 'harmonymidi'
module Invoke
#-----------------------------
  class Play
    include ChordUtilities

    def initialize( note_space_width)
#p 'in Invoke::Play#initialize'
      load_all( note_space_width)
    end

    def run
#p 'in Invoke::Play#run'
      select()
      intervals_used = []
      highest_note = 0
# TO-DO: Count rooted chords in necklaces: should be 2048.
      HarmonyMidi::Play.set_up()
      unless @select_necklaces_indices.empty?
print '@select_necklaces_indices '; p @select_necklaces_indices
      end
print "\nTable of Necklaces: '111111111111' (MSB to LSB) means:\n"
print "G F# F E Eb D C# C B Bb A Ab, 0,1,2,3,4,5,6,7,8,9,10,11, [0,11,10,9,8,7,6,5,4,3,2,1].\n"
print "Necklace: binary - notes 'not' silent letters\n"
print "MIDI_time inversion - name [absolute] letters\n"
      transposition = 0
      (0...(@select_necklaces_indices.empty? ? @note_space.necklaces : @select_necklaces_indices).
      length).each do |necklace_index|
        necklace_number = @select_necklaces_indices.empty? ? necklace_index : @select_necklaces_indices.at( necklace_index)
        necklace = @note_space.necklaces.at( necklace_number)
        had_pause = false
        (necklace.roots.length - 1).downto( 0) do |i|
          chords = necklace.roots.at( i)
          next if chords.nil?
          array = chords.compact
          next if array.nil? || array.empty?
          (had_pause = true; HarmonyMidi::Play.handle_necklace( necklace, necklace_number)) unless had_pause
          array.each do |chord|
            intervals_used += absolutes_to_intervals( chord.absolutes)
            intervals_used.sort!.uniq!
            highest_note = chord.absolute#print 'chord.absolutes '; p chord.absolutes
s.last if chord.absolutes.last > highest_note
            HarmonyMidi::Play.handle_chord( @note_space, chord.absolutes, necklace.root_numbers.at( i), get_chord_name( chord.absolutes), transposition)
            if 0 == transposition % 7
              transposition -= 4
            else
              transposition -= 3
            end #if
          end #each chord
        end #downto i
      end #each necklace_index
      HarmonyMidi::Play.tear_down()
      print 'intervals_used '; p intervals_used
      print 'highest_note '; p highest_note
    end

    def get_chord_name( absolutes)
      have = Array.new( 12, false)
      absolutes.each {|note| have[ note % 12] = true}
      minor_ninth                  =  1 # Intervals from G to: Ab.
      ninth                        =  2 # A.
      minor                        =  3 # Bb.
      major                        =  4 # B.
      eleventh                     =  5 # C.
      diminished = major_eleventh  =  6 # C#.
      fifth                        =  7 # D.
      augmented = minor_thirteenth =  8 # Eb.
      sixth = thirteenth           =  9 # E.
      seventh                      = 10 # F.
      major_seventh                = 11 # F#.
      letter = (have.at( major) && ! have.at( minor)) ? 'I' : 'i'
      type = get_type( have, minor, major, diminished, fifth, augmented, sixth)
      flavored = (                          have.at(    major_seventh)  ? 'j7'  : '') +
                 (                          have.at(      minor_ninth)  ? 'm9'  : '') +
                 ((! type.include?( 'd') && have.at(   major_eleventh)) ? 'j11' : '') +
                 (('a' != type           && have.at( minor_thirteenth)) ? 'm13' : '')
      compatible = []
      [ minor_thirteenth, major_eleventh, minor_ninth, major_seventh].inject( true) do |memo, e|
        have_this_value = have.at( e)
        have_this_value = false if minor_thirteenth == e && 'a' == type
        have_this_value = false if   major_eleventh == e && type.include?( 'd')
        compatible.push( set_to = memo && ! have_this_value)
        set_to
      end #inject memo, e
      compatible.reverse!
      plain = ''
      [[ seventh, '7'], [ ninth, '9'], [ eleventh, '11'], [ thirteenth, '13']].
      each_with_index do |e, i|
        interval, interval_string = e.first, e.last # Maybe use Struct.
        if have.at( interval) && compatible.at( i)
#?          if (! type.include?( 'd') && eleventh == interval) ||
          unless ('d6' == type && thirteenth == interval)
            plain = interval_string
          end #unless
        end #if
      end #each_with_index e, i
      intervals = flavored + plain
      eliminations = Array.new( 11.succ, nil) # Eliminate these intervals from the chord.
# Assume we have a higher interval, and check for the absence of this interval.
      eliminations[  3] =  3 unless [    major,    minor      ].detect {|e| have.at( e)}
      eliminations[  7] =  7 unless [  seventh,  major_seventh].detect {|e| have.at( e)}
      eliminations[  9] =  9 unless [    ninth,    minor_ninth].detect {|e| have.at( e)}
      eliminations[ 11] = 11 unless [ eleventh, major_eleventh].detect {|e| have.at( e)}
      eliminations[ 11] = 11 if ( ! have.at(          eleventh)) && type.include?( 'd')
      eliminations[  5] =  5 unless have.at(             fifth)  || type.include?( 'd') || 'a' == type
# Check for the absence of any higher interval.
      if     [ thirteenth, minor_thirteenth].detect {|e| have.at( e)}.nil? ||
                     ('d6' == type        && ! have.at( minor_thirteenth)) ||
                     ('a'  == type        && ! have.at(       thirteenth))
            eliminations[ 11] = nil
        if   [   eleventh,   major_eleventh].detect {|e| have.at( e)}.nil? ||
                     (type.include?( 'd') && ! have.at(         eleventh))
            eliminations[  9] = nil
          if [      ninth,      minor_ninth].detect {|e| have.at( e)}.nil?
            eliminations[  7] = nil
          end
        end
      end #if
      eliminations = eliminations.compact.join(',')
      eliminations = 'x' + eliminations unless '' == eliminations
      suspensions = Array.new( 13.succ, nil) # Add these intervals to the chord.
      suspensions[  3] =  3 unless [ major,      minor           ].detect {|e| ! have.at( e)}
      suspensions[  7] =  7 unless [ seventh,    major_seventh   ].detect {|e| ! have.at( e)}
      suspensions[  9] =  9 unless [ ninth,      minor_ninth     ].detect {|e| ! have.at( e)}
      suspensions[ 11] = 11 unless [ eleventh,   major_eleventh  ].detect {|e| ! have.at( e)} || type.include?( 'd')
      suspensions[ 13] = 13 unless [ thirteenth, minor_thirteenth].detect {|e| ! have.at( e)} || [ 'a', 'd6'].include?( type)
      suspensions[  5] =  5 if have.at( fifth) && (type.include?( 'd') || 'a' == type)
      suspensions = suspensions.compact.join(',')
      suspensions = 's' + suspensions unless '' == suspensions
      letter + type + intervals + eliminations + suspensions
    end #def

    def get_type( have, minor, major, diminished, fifth, augmented, sixth)
      return '' if have.at( fifth)
      return '' if [diminished, augmented].detect {|e| have.at( e)}.nil?
      type = ''
      if have.at( diminished) && ! have.at( major)
        type = [ minor, sixth].detect {|e| ! have.at( e)} ? 'd' : 'd6'
      elsif have.at( augmented) && have.at( major)
        type = 'a'
      end
      type
    end #def

  end #class Play
end #module Invoke
