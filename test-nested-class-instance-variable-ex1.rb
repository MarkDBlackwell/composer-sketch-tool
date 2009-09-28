class E
class A
  @foo = 'one'
  class << self
    attr_accessor :foo
  end
end
end
a = E::A.new
class B < E; end
b = B::A.new
class C < E; end
c = C::A.new

p E::A.foo              # =>'one'
p a.class.foo           # =>'one'
p B::A.foo              # =>'one'
p b.class.foo           # =>'one'
p C::A.foo              # =>'one'
p c.class.foo           # =>'one'

b.class.foo = 'three'

p E::A.foo              # =>'three'
p a.class.foo           # =>'three'
p B::A.foo              # =>'three'
p b.class.foo           # =>'three'
p C::A.foo              # =>'three'
p c.class.foo           # =>'three'

a.class.foo = 'two'

p E::A.foo              # =>'two'
p a.class.foo           # =>'two'
p B::A.foo              # =>'two'
p b.class.foo           # =>'two'
p C::A.foo              # =>'two'
p c.class.foo           # =>'two'
