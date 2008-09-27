require File.join(File.dirname(__FILE__),"..","test_helper")

context "For Master process" do
  include EmWorker::Helper
  setup do
    EventMachine.stubs(:run)
    @em_master = EmWorker::EmMaster.new("hello")
  end

  specify "should invoke log for undefined external message" do
    data = object_dump("hello world")
    @em_master.log.expects(:info).with("hello world")
    @em_master.receive_data(data)
  end
end
