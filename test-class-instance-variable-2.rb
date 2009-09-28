#Ruby version: ruby 1.8.6 (2007-03-13 patchlevel 0) [i386-mswin32]
# Class instance variables
# Nested classes conflict with class instance variables.
class A
  class << self
    attr_accessor :b
    private
    attr_accessor :c
  end #class << self
  @a = 'from-a'
  @b = 'from-b'
  @c = 'from-c'
  def A.generate_e
    @e = 'from-e'
  end
  def A.see_a
    @a
  end
  def A.see_b
    @b
  end
  def A.see_e
    @e
  end
  def instance_see_name
#   A.a                  #=>raises 'undefined method `a' for A:Class (NoMethodError)'
#   A.c                  #=>raises 'private method `c' called for A:Class (NoMethodError)'
    A.b                  #In B, gets class variable of A (probably undesired).
  end
  def instance_see_self_class
#   self.class.a         #=>raises 'undefined method `a' for A:Class (NoMethodError)'
#   self.class.c         #=>raises 'private method `c' called for A:Class (NoMethodError)'
    self.class.b         #In B, gets class variable of B.
  end
end #class A
# In class B (a different class instance), expect no access to A's class instance variables.
class B < A; end
A.generate_e
B.generate_e
p A.see_a, A.b, A.see_b, A.see_e  #=>'from-a', 'from-b', 'from-b', 'from-e'
p B.see_a, B.b, B.see_b, B.see_e  #=>nil, nil, nil, 'from-e'
A.b = 'reset'
B.b = 'new'
p A.new.instance_see_name, A.new.instance_see_self_class  #=>'reset', 'reset'
p B.new.instance_see_name, B.new.instance_see_self_class  #=>'reset', 'new'
A.b = 'from-A.b-outside'
B.b = 'from-B.b-outside'
p A.b, A.see_b           #=>'from-A.b-outside', 'from-A.b-outside'
p B.b, B.see_b           #=>'from-B.b-outside', 'from-B.b-outside'

#A.a = 'from-a-outside'  #=>raises 'undefined method `a=' for A:Class (NoMethodError)'
#B.a = 'from-a-outside'  #=>raises 'undefined method `a=' for B:Class (NoMethodError)'
#p A.a                   #=>raises 'undefined method `a' for A:Class (NoMethodError)'
#p B.a                   #=>raises 'undefined method `a' for B:Class (NoMethodError)'
#p A.c                   #=>raises 'private method `c' called for A:Class (NoMethodError)'
#p B.c                   #=>raises 'private method `c' called for B:Class (NoMethodError)'
#A.d = 'from-d-outside'  #=>raises 'undefined method `d=' for A:Class (NoMethodError)'
#B.d = 'from-d-outside'  #=>raises 'undefined method `d=' for B:Class (NoMethodError)'
#p A.e                   #=>raises 'undefined method `e' for A:Class (NoMethodError)'
#p B.e                   #=>raises 'undefined method `e' for B:Class (NoMethodError)'


