class A
  def A.x
    'one'
  end

  def self.y
    'two'
  end

  def A.a
    return A.x, self.y
  end

  def self.b
    return A.x, self.y
  end

  def A.c
    return A.x, self.y
  end

  def self.d
    return A.x, self.y
  end
end

class B < A
  def B.x
    'three'
  end

  def self.y
    'four'
  end
end
p B.a, B.b, B.c, B.d   # => ["one","four"],["one","four"],["one","four"],["one","four"]