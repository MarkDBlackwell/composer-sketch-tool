require 'spec'
require 'build'
#-----------------------------
describe "Build" do
  def open
    result = nil
    File.open( 'log/build.txt', 'r') {|f| result = f.readlines.length}
    result
  end
  before( :each) do
    @before = open()
    Invoke::Build.new( 0)
  end
  it "should log one line" do
    (open() - @before).should == 1
  end
end
#-----------------------------
describe "While saving chords, Build" do
  def check_return_mock_my_file
    @receive_new.and_return( @mock_my_file)
  end
  def check_receive_print_close( *args)
    o = @mock_my_file.should_receive( :print)
    o.with( args.first) unless args.empty?
    @mock_my_file.should_receive( :close)
  end
  before( :each) do
    @mock_my_file = mock( InvokeUtilities::MyFile)
    @receive_new = InvokeUtilities::MyFile.should_receive( :new)
  end
  it "should save into the right file name" do
    @receive_new =
    @receive_new.with( 'marshal/chords-0.txt', 'w')
    check_return_mock_my_file()
    check_receive_print_close()
  end
  it "should save the correct contents" do
    check_return_mock_my_file()
    check_receive_print_close( 'contents-0')
  end
  after( :each) do
    Invoke::Build.new( 0).save_chords() # Assume this uses MyFile to write.
  end
end
#-----------------------------
describe "While saving necklaces, Build" do
  def check_return_mock_my_file
    @receive_new.and_return( @mock_my_file)
  end
  def check_receive_print_close( *args)
    o = @mock_my_file.should_receive( :print)
    o.with( args.first) unless args.empty?
    @mock_my_file.should_receive( :close)
  end
  before( :each) do
    @mock_my_file = mock( InvokeUtilities::MyFile)
    @receive_new = InvokeUtilities::MyFile.should_receive( :new)
  end
  it "should save into the right file name" do
    @receive_new =
    @receive_new.with( 'marshal/necklaces-0.txt', 'w')
    check_return_mock_my_file()
    check_receive_print_close()
  end
  it "should save the correct contents" do
    check_return_mock_my_file()
    check_receive_print_close( 'contents-0')
  end
  after( :each) do
    Invoke::Build.new( 0).save_necklaces() # Assume this uses MyFile to write.
  end
end
#-----------------------------
describe "Build's logger" do
  def check_receive_debug
    @mock_logger.should_receive( :debug)
  end
  def allow_return_mock_logger
    @receive_new.and_return( @mock_logger)
  end
  before( :each) do
    @mock_logger = mock( InvokeUtilities::MyLogger)
    @receive_new = InvokeUtilities::MyLogger.should_receive( :new)
  end
  it "should receive exactly one call" do
    allow_return_mock_logger()
    check_receive_debug().once
  end
  it "should use the right file name" do
    @receive_new =
    @receive_new.with( 'log/build.txt')
    allow_return_mock_logger()
    check_receive_debug().any_number_of_times
  end
  it "should include the right message" do
    allow_return_mock_logger()
    check_receive_debug().with( 'in Invoke::Build#initialize').any_number_of_times
  end
  after( :each) do
    Invoke::Build.new( 0) # Assume this uses MyLogger to log.
  end
end
