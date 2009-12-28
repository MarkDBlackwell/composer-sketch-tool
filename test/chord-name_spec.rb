require 'spec'
require 'chordname'
#-----------------------------
describe "ChordName" do
  it "must do something" do
    chord_name = ChordName.new()
    chord_name.to_s.should == ''
  end
end
