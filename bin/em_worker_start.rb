#!/usr/bin/env ruby

dir = File.dirname(__FILE__)
$:.unshift(File.join(dir,"..","lib"))
require "em_worker"
EmWorker::EmMaster.start_master_process
