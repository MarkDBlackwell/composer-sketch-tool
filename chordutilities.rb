module ChordUtilities
  def absolutes_to_intervals( absolutes)
    previous = absolutes.first
    absolutes.collect {|e| result = e - previous; previous = e; result}
  end

  def any_duplicates?( absolutes, length)
    have_note = Array.new( length).fill( false)
    absolutes.any? {|note| already =
    have_note.at( note % length)
    have_note[    note % length] = true; already}
  end #def

  def count_interval( absolutes, interval)
    absolutes.inject( 0) {|memo, low| memo + absolutes.find_all {|high| high - low == interval}.length}
  end

  def count_space( absolutes, interval)
    absolutes_to_intervals( absolutes).find_all {|e| e >= interval}.length
  end

  def intervals_to_absolutes( intervals)
    previous = 0
    [0] + intervals.collect {|e| previous += e}
  end

  def missing( absolutes, octave)
    collapsed = absolutes.collect {|e| e % octave}.sort!
    Chord.new((0...octave).reject {|e| collapsed.include?( e)})
  end

  def normalize( word, width)
    most_significant_bit_value = Bit::BIT_VALUE_1 << (width - 1)
    (1..width).collect do
      least_significant_bit_was_set = Bit::BIT_VALUE_1 == word & Bit::SINGLE_BIT
      word >>= Bit::SINGLE_BIT
      word += most_significant_bit_value if least_significant_bit_was_set
      word
    end.max
  end #def

  def notes_per_octave( value, octave)
    value.length/(value.last.to_f/octave)
  end

  def out_of_order?( absolutes)
    absolutes.sort != absolutes
  end
end #module ChordUtilities