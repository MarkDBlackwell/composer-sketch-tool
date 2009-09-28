#Ruby version: ruby 1.8.6 (2007-03-13 patchlevel 0) [i386-mswin32]
class A
  @foo = 'one'
  class << self
#    attr_accessor :foo # Okay to use this, too.
    def foo
      @foo
    end
    def foo=( v)
      @foo = v
    end
  end #class << self
end #class A
a = A.new
class B < A; end
b = B.new
class C < A; end
c = C.new

p A.foo              # =>'one'
p a.class.foo        # =>'one'
p B.foo              # =>nil
p b.class.foo        # =>nil
p C.foo              # =>nil
p c.class.foo        # =>nil

a.class.foo = 'two'

p A.foo              # =>'two'
p a.class.foo        # =>'two'
p B.foo              # =>nil
p b.class.foo        # =>nil
p C.foo              # =>nil
p c.class.foo        # =>nil

b.class.foo = 'three'

p A.foo              # =>'two'
p a.class.foo        # =>'two'
p B.foo              # =>'three'
p b.class.foo        # =>'three'
p C.foo              # =>nil
p c.class.foo        # =>nil
