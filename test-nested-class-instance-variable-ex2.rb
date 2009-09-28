#Ruby version: ruby 1.8.6 (2007-03-13 patchlevel 0) [i386-mswin32]
class E
class A
  @foo = 'one'
  class << self
    attr_accessor :foo
  end
end
end
a = E.new
class B < E; end
b = B.new
class C < E; end
c = C.new

p E::A.foo              # =>'one'
p a.class::A.foo        # =>'one'
p B::A.foo              # =>'one'
p b.class::A.foo        # =>'one'
p C::A.foo              # =>'one'
p c.class::A.foo        # =>'one'

b.class::A.foo = 'three'

p E::A.foo              # =>'three'
p a.class::A.foo        # =>'three'
p B::A.foo              # =>'three'
p b.class::A.foo        # =>'three'
p C::A.foo              # =>'three'
p c.class::A.foo        # =>'three'

a.class::A.foo = 'two'

p E::A.foo              # =>'two'
p a.class::A.foo        # =>'two'
p B::A.foo              # =>'two'
p b.class::A.foo        # =>'two'
p C::A.foo              # =>'two'
p c.class::A.foo        # =>'two'
