dir = File.dirname(__FILE__)
$:.unshift(dir) unless $:.include?(dir)
require "rubygems"
require "eventmachine"
require "forwardable"

module EmWorker
  VERSION = "0.0.1"
  autoload :Runner, "em_worker/runner"
  autoload :BaseWorker, "em_worker/base_worker"
  autoload :BinParser, "em_worker/binary_parser"
  autoload :Runner, "em_worker/em_runner"
  autoload :EmMaster, "em_worker/em_master"
  autoload :Base, "em_worker/em_base"
  autoload :Helper, "em_worker/em_worker_helper"
  autoload :Log, "em_worker/em_log"
end
