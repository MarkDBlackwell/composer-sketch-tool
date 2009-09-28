class A
  @foo = 'one'
  class << A
    attr_accessor :foo
  end
end
a = A.new
class B < A
end
b = B.new

p A.foo              # =>'one'
p a.class.foo        # =>'one'
p B.foo              # =>nil
p b.class.foo        # =>nil

a.class.foo = 'two'
p A.foo              # =>'two'
p a.class.foo        # =>'two'
p B.foo              # =>nil
p b.class.foo        # =>nil

b.class.foo = 'three'
p A.foo              # =>'two'
p a.class.foo        # =>'two'
p B.foo              # =>'three'
p b.class.foo        # =>'three'
