def format( n=note_space_size, a=an_array)
  a.collect {|e| format_one( n, e)}
end

def format_one( n=note_space_size, a=an_array)
  chord =[]
  (n - 1).downto( 0) do |note|
    chord.push( note) if a % 2 ==1
    a /=2
  end
  chord.reverse.join( ',')
end

def generate_chords( n=note_space_size) #1 to 2**12 - 1 == 1, 2, 3
  (1..2**n).to_a
end

def generate_measure( s=a_string)
end

def generate_normalized_chords( n=note_space_size)
  sort_and_remove_duplicates( keep_highest( n, generate_chords( n)))
end

def generate_time_tree( a=an_array)
end

def keep_highest( n=note_space_size, a=an_array)
  a.collect {|e| normalize( n, e)}
end

def normalize( n=note_space_size, a=an_array)
  (1..n).collect do
    had_low =a % 2 ==1
    a /=2
    a += 2**( n - 1) if had_low
    a
  end.max
end

def size_tree( a=an_array)
end

def sort_and_remove_duplicates( a=an_array)
  a.sort.uniq!
end
#------------------
puts generate_normalized_chords( note_space_size=12).size
puts format( note_space_size=12, sort_and_remove_duplicates( keep_highest( note_space_size=12, generate_chords( note_space_size=12))))

#(1..100).each do |note_space_size|
#  p [note_space_size, generate_normalized_chords( note_space_size).size]
#end
