=begin
all-chords.rb
This is a Ruby program to create all the chords possible from the Western 12 tones, collapsing inversions and transpositions.
Transposition is sliding in parallel the pitches of a whole chord.
Inversion is selecting a different root note from among the chord notes, making it the lowest by octave movement.

Following test-first development.
Author: Mark D. Blackwell
Written: 2009, January 7
Changed: 2009, January 17

Heedless of inversion and duplication, there are 2**12 chords, including silence. Inversion divides by 12, leaving 2**10/3 chores. Something wrong, there (1/3 or 2/3 of a chord). Inversion doesn't divide.

Start with all chords but silence: 1 to 2**12 - 1.
Sort, removing duplicates.
Make and keep binary, 12-bit numbers.
Rotate the 12 bits, keeping the interpreted highest integer number.
2**0 ... 2**9 2**10 2**11
12 ... 3 2 1
Ab ... F F# G
The binary nuerical bits are G F# F E Eb D C# C B Bb A Ab = 2**11 ... 2**0.
0,1,2 ... 11 is G F# F E Eb D C# C B Bb A Ab.

Offer all chords to listener. Space in thirds.
=end
#------------------
def format( n=note_space_size, a=an_array)
  a.collect {|e| format_one( n, e)}
end

def format_one( n=note_space_size, a=an_array)
  chord =[]
# Bits 0, 1, 2 ... 9, 10, 11 give 11, 10, 9 ... 2, 1, 0 for Ab A Bb ... F F# G, then the order is reversed.
# Why not switch to using min and MSB to LSB 11, 10, 9 ... 2, 1, 0 for Ab A Bb ... F F# G?
# To wit: max 110010 becomes 010011. Is it min? No: min is 001101. The sequence of necklaces would become different.
# So, keeping MSB to LSB, 11, 10, 9 ... 2, 1, 0 is G F# F E Eb D C# C B Bb A Ab.


  (n - 1).downto( 0) do |note|
    chord.push( note) if a % 2 ==1
    a /=2
  end
  chord.reverse.join( ',')
end

def generate_chords( n=note_space_size) #1 to 2**12 - 1 is 1, 2, 3
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
puts generate_normalized_chords( note_space_size=12).size
puts format( note_space_size=12, sort_and_remove_duplicates( keep_highest( note_space_size=12, generate_chords( note_space_size=12))))

#(1..100).each do |note_space_size|
#  p [note_space_size, generate_normalized_chords( note_space_size).size]
#end
#------------------
alias_method :g_c,   :generate_chords
alias_method :g_m,   :generate_measure
alias_method :g_n_c, :generate_normalized_chords
alias_method :g_t_t, :generate_time_tree
alias_method :k_h,   :keep_highest
alias_method :s_r_d, :sort_and_remove_duplicates

assert [ 4, 5, 6, 7].collect do |e|
  format_one( note_space_size=3, e)
end==[ '1', '1,3', '1,2', '1,2,3']

assert g_c( note_space_size=2) ==[ 1, 2, 3] #F#, G, F# G.

assert k_h( note_space_size=2, g_c( note_space_size=2)) ==[ 2, 2, 3] #G, G, F# G.

assert s_r_d( k_h( note_space_size=2, g_c( note_space_size=2))) ==[3, 2]

assert g_c( note_space_size=3) ==[ 1, 2, 3, 4, 5, 6, 7] #F, F#, F F#, G, F G, F# G, F F# G.

assert k_h( note_space_size=3, g_c( note_space_size=3)) ==[ 4, 4, 6, 4, 5, 6, 7]

assert s_r_d( k_h( note_space_size=3, g_c( note_space_size=3))) ==[4, 5, 6, 7] #1 1,3 1,2 1,2,3 (001, 101, 011, 111)

assert [ 1, 2, 3, 4, 5, 6, 7].collect do |e|
  normalize( note_space_size=3, e)
end==[ 4, 4, 6, 4, 5, 6, 7]

assert g_n_c( note_space_size=3) ==[4, 5, 6, 7]

assert format( note_space_size=3, [ 4, 5, 6, 7]) ==[ '1', '1,3', '1,2', '1,2,3']

assert g_t_t( 1., '(i _ _ _) ; _') ==[ .125, .125, .125, .125, .5]

assert gen_mode( 'a') ==[ 0, 2, 3, 5, 7, 8, 10]
assert gen_mode( 'A') ==[ 0, 2, 4, 5, 7, 9, 11]

a =g_m( 1., 'i (_ _) _')
assert a.is_array? && a.size ==3 && a[ 1].is_array? && a[ 1].size ==2

assert g_m( 2., 'i')[ 0].time ==2.

a =g_m( 1., '(i i i i) i')
assert a[ 1].time ==.5 && (0..4).collect do |i|
  .125 ==a[ 0][ i].time
end ==[ true, true, true, true]

s='vix3'
a =g_m( 1., s +' _')
assert a[ 1].chord_name ==s && a[ 0].chord_name ==s

assert g_m( 1., 'i')[ 0].time ==1.

assert g_m( 1., 'i')[ 0].chord_name =='i' &&
       g_m( 1., 'v')[ 0].chord_name =='v'

assert g_m( 10., 'i _').collect {|e| e.time} ==[ .5, .5]

a =g_m( 8., 'i (_ _)')
assert a.time ==[ 4., [ 2., 2.]]
assert a.collect do |e| if not e.is_array?
  e.time else e.collect {|b| b.time}
end ==g_t_t( a)

assert g_t_t( g_m( 8., '(i _) _')) ==[[ 2., 2.], 4.]

assert g_t_t( g_m( 6., 'i ; _')) ==[ 3., 3.]

assert g_t_t( g_m( 8., 'i _ _ _ ; _ _ _ _')) ==Array( 1., 8)

assert g_t_t( g_m( 16., 'i _ _ _ ; (_ _)(_ _) _ _')) ==[ 2., 2., 2., 2., [ 1., 1.], [ 1., 1.], 2., 2.]

assert g_t_t( g_m( 4., '(i _) (_ _)') ==[[ 1., 1.], [1., 1.]]

assert g_t_t( g_m( 1., "i \n _")) ==[ .5, .5]

a =g_m( 1., 'a: i')
assert a.key =='a'
#assert a.midi =='142' #or something.
#------------------------------------
(_ _ _ _) ; _ #73
_ _ _ _ ; _ _ _ _ #66
_ _ _ _ ; (_ _)(_ _) _ _ #67
_ _ _ _ ; (_ _)(_ _)(_ _)(_ _) #76
(_ _)(_ _) _ _ ; _ (_ _) _ _ #77
(_ _)(_ _) _ _ ; _ _ (_ _)(_ _) #78
_ _ ; (_ _)(_ _ _ _) #82
(_ _)(_ _) ; (_ _) rest #86
_ ; (_ _ (_ _)(_ _)) #87
_ _ (_ _)(_ _) ; _ _ (_ _)(_ _) #88
_ (_ _ _ _) _ _ ; _ (_ _ _ _) _ _ #93
_ _ _ _ ; _ (_ _ _ _) _ _ #94
_ (_ _ _ _) _ _ ; _ _ _ _ #95
(_ _ (_ _)(_ _)) ; _ #96
_ _ (_ _) #26
(_ _ _ _) _ _ #27
(_ _)(_ _) _ _ ; _ (_ _ _ _) _ _ #64
9-12: G: _ _ #9

I
G B D
8 4 1
1 3 5
i
G Bb D
4 1 9
1 3 5
I11x5
G B F A C
6 2 8 4
1 3 7 2 4
I7
G B D F
1 9 6 3
1 3 5 7
i7
G Bb D F
1 10 6 3
1 3 5 7
i7x3
G D F
1 6 3
1 5 7
i7x3,5
G F
1 3
1 7
i7x3s4
G C D F
1 8 6 3
1 4 5 7
I7x5
G B F
1 9 3
1 3 7
i7x5
G Bb F
1 10 3
1 3 7
i9x5
G Bb F A
4 1 6 2
1 3 7 2
I9x7
G B D A
5 1 10 3
1 3 5 2
Iaug7
G B D# F
1 9 5 3
1 3 5 7
id
G Bb Db
7 4 1
1 3 5
id6
G Bb Db E
10 7 4 1
1 3 5 6
id6min9x7
G Bb Db E Ab
2 11 8 5 1
1 3 5 6 2
id7
G Bb Db F
1 10 7 3
1 3 5 7
id7x3
G Db F
1 7 3
1 5 7
idmin9
G Bb Db F Ab
2 11 8 4 1
1 3 5 7 2
ids5
G Bb Db D
8 5 2 1
1 3 5d 5
idx3
G Db
7 1
1 5
idx3s5
G Db D
8 2 1
1 5d 5
Imaj7
G B D F#
1 9 6 2
1 3 5 7
Imaj79x5
G B F# A
1 9 2 11
1 3 7 2
Imaj7x5
G B F#
1 9 2
1 3 7
imin9
G Bb D F Ab
2 11 7 4 1
1 3 5 7 2
imin9x3
G D F Ab
2 7 4 1
1 5 7 2
imin9x7
G Bb D Ab
2 11 7 1
1 3 5 2
ix3
G D
1 6
1 5
ix3,5
G
1
1
ix3s4
G C D
8 3 1
1 4 5
Ix5
G B
5 1
1 3
ix5
G Bb
4 1
1 3