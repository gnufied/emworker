dir = File.dirname(__FILE__)
$:.unshift(File.join(dir,"..","lib"))
require "em_worker"
EmWorker::Runner.new(ARGV)
