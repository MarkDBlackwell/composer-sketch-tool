class E
  class A
    @foo = 'bar'
    class << A
      attr_accessor :foo
    end
    def a
      p self.class.foo
    end
    def A.b
      p foo
    end
  end
end
c = E::A.new
c.a
c.class.b
p c.class.foo
c.class.foo = 'yuk'
p c.class.foo
class B < E
end
d = B::A.new
d.a
d.class.b
