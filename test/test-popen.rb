f = IO.popen("uname")
p f.readlines
puts "Parent is #{Process.pid}"
IO.popen( "date") {|f| puts f.gets; f.gets}
#IO.popen( "-") {|f| $stderr.puts "#{Process.pid} is here, f is #{f}"}
p $?
