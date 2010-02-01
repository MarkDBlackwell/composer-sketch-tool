require 'spec'
require 'invokeutilities'
#-----------------------------
describe "MyFile" do
  def read
    result = nil # Expand scope.
    File.open( @file_name, 'r') {|file| result = file.readlines}
    result
  end
  before :each do
    @file_name = 'test-my-file-actual-write.txt' # Similar to class name.
    File.open( @file_name, 'w') {|file| file.write 'aaa'}
  end
  it "should actually write to a file" do
    a = read()
#    print ['test', 'warning'].join '-' + 'hello'
    a.last.should == 'aaa'
    InvokeUtilities::MyFile.open( @file_name, 'w') {|file| file.write 'bbb'}
#   Process.exit! # Exit without being trapped by test-package software.
    a = read()
    a.length.should == 1
    a.last.should == 'bbb'
  end
  after :each do
    File.delete( @file_name)
  end
end
