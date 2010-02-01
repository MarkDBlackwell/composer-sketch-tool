require 'spec'
require 'firsttestfirst'
#-----------------------------
module FirstTestFirst
  describe "FirstTestFirst" do
    it "must do something" do
      first_test_first = FirstTestFirst.new()
      first_test_first.something.should == 'something'
    end
  end
end # module FirstTestFirst
