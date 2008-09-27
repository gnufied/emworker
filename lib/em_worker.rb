dir = File.dirname(__FILE__)
$:.unshift(dir) unless $:.include?(dir)

require "rubygems"
require "eventmachine"
require "forwardable"
require "ostruct"

module EmWorker
  VERSION = "0.0.1"
  autoload :Runner, "em_worker/worker_runner"
  autoload :BaseWorker, "em_worker/base_worker"
  autoload :BinParser, "em_worker/binary_parser"
  autoload :EmMaster, "em_worker/em_master"
  autoload :Base, "em_worker/em_base"
  autoload :Helper, "em_worker/em_worker_helper"
  autoload :Log, "em_worker/em_log"
end
