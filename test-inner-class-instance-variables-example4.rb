class A
  class << self
    attr_accessor :foo
  end
end
a = A.new
class B < A
end
b = B.new

a.class.foo = 'bar'
p a.class.foo
p b.class.foo
p A.foo

b.class.foo = 'yuk'
p a.class.foo
p b.class.foo
p B.foo
