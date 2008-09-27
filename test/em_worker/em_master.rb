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

  specify "should invoke process hello hello worker for initial requests" do
    @em_master.server_port = 9000
    @em_master.server_ip = "localhost"
    data1 = object_dump(:worker => "hello",:worker_key => "world",:data => "hello world",:type => :start_worker)
    @em_master.expects(:fork_and_load).with({:data=>"hello world", :worker=>"hello", :worker_key=>"world"})
    @em_master.receive_data(data1)


    data = object_dump(:worker => "hello",:type => :worker_hello,:worker_key => "world")
    @em_master.expects(:send_data)  #with(object_dump({:data=>"hello world", :worker=>"hello", :worker_key=>"world"}))
    @em_master.receive_data(data)
  end
end
