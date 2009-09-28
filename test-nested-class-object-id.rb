class A
p self.object_id, self.class
  class B
p self.object_id, self.class
    class << self
p self.object_id, self.class
    end
  end
end
class C
p self.object_id, self.class
  class << self
p self.object_id, self.class
  end
end
a=A.new