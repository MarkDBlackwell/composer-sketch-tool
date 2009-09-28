class E
  class A
    class << self
      attr_accessor :foo
    end
  end
end
a = E::A.new
class B < E
end
b = B::A.new

a.class.foo = 'bar'
p a.class.foo
p b.class.foo

b.class.foo = 'yuk'
p a.class.foo
p b.class.foo
