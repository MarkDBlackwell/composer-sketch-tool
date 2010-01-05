# Vague way to use Infrastructure component Streamer to handle command line argument list in each Unix tool program, e.g., hex2chord.

class Streamer
  def invoke( biter)
    $args etc.
    IO.something until EOF
      biter.translate()
    end
  end
end

class Main
  def self.Main
    biter = Hex2chord.new
    Streamer.new().invoke( biter)
  end
end
