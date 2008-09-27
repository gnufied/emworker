#!/usr/bin/env ruby

dir = File.dirname(__FILE__)
$:.unshift(File.join(dir,"..","lib"))
require "em_worker"
WORKER_ROOT = File.join(dir,"..","workers")
EmWorker::EmMaster.start_master_process
