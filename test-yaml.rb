class Square
attr_reader :width
def initialize width,height
@width=width
@height=height
@bonus=['yo',{:msg => 'YAML 4TW'}]
@me=self
end
end
serialized = Square.new(2,2).to_yaml
new_obj = YAML::load(serialized)
puts new_obj.width