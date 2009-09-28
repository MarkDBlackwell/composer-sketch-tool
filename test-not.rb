p (not true && true)
p (not true && false)
p (not false && true)
p (not false && false)

p (! true && true)
p (! true && false)
p (! false && true)
p (! false && false)
=begin
yields:

false
true
true
true

false
false
true
false

=end