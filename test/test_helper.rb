dir = File.dirname(__FILE__)
$:.unshift(File.join(dir,"..","lib"))
require "test/spec"
require "mocha"
require "em_worker"
