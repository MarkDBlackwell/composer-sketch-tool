parser.rb
#Use standard library string method, 'scan' (see the Pickaxe book).

def assert( b=a_boolean)
  p b
end

def scan_harmony( s=a_string)
  s.scan( %r{\||_|\(|\)|[^|_()\s]+} )
end

def get_chords
  chord_roots =%w{I II III IV V VI VII}
  a =%w{I i I11x5 I7 i7 i7x3 i7x3,5 i7x3s4 I7x5 i7x5 i9x5 I9x7 Iaug7 id id6 id6min9x7 id7 id7x3 idmin9 ids5 idx3 idx3s5 Imaj7 Imaj79x5 Imaj7x5 imin9 imin9x3 imin9x7 ix3 ix3,5 ix3s4 Ix5 ix5}
  chord_names =a + %w{2 3 4 5 5d 6 7}.collect {|bass| a.collect {|e| e +'/' +bass}}.flatten
  chord_names.collect do |name|
    is_major =name.slice( 0, 1) =='I'
    after = name.length <= 1 ? '' : name.slice( 1, name.length - 1)
    chord_roots.collect do |root|
      [ '-', '+', ''].collect do |alteration|
        alteration +( is_major ? root : root.downcase) +after
      end
    end
  end.flatten
end

def read_program
  music =[]
  f=File.open( 'mozart-agnus-dei.txt')
  f.each do |s|
    music.push( scan_harmony( s))
  end
  music.flatten!
#  p music

  symbols =[ '_', '|', '(', ')', 'rest']
  c =':'
  a =%w{A B C D E F G}
  keys =a.collect {|e| [e +c, e.downcase + c]}.flatten
  valid_tokens = get_chords + symbols +keys
  music.delete_if {|e| not valid_tokens.include? e}
  puts music
end

#test-first
#alias_method :scan_harmony, :s_h

#assert scan_harmony( 'dd | aa (bb idx3s5 77y cc)|')==['dd', '|', 'aa', '(', 'bb', 'idx3s5', '77y', 'cc', ')', '|']
#p ['dd', '|', 'aa', '(', 'bb', 'idx3s5', '77y', 'cc', ')', '|']
#puts

read_program
