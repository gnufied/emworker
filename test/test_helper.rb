dir = File.dirname(__FILE__)
$:.unshift(File.join(dir,"..","lib","em_worker"))
require "test/spec"
require "mocha"
