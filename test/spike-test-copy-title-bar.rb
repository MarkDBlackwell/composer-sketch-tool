saved_string = nil
Shoes.app do
  @o = oval :top => 0, :left => 0, :radius => 40
  stack :margin => 40 do
    title (saved_string = "Dancing With a Circle")
#    title "#{@o.inspect}\n#{Shoes.inspect}\n#{App.inspect}\n#{self.inspect}\n\Dancing With a Circle"
    subtitle "How graceful and round."
  end
  motion do |x, y|
    @o.move width - x, height - y
  end
end
Shoes.app do
  stack :margin => 40 do
    title saved_string
  end
end
