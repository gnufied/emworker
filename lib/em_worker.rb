dir = File.dirname(__FILE__)
$:.unshift(dir) unless $:.include?(dir)

require "rubygems"
require "eventmachine"
require "forwardable"
require "ostruct"
require "attributes"
require "chronic"
require "time"
require "daemons"

module EmWorker
  VERSION = "0.0.1"
  autoload :Runner, "em_worker/worker_runner"
  autoload :BaseWorker, "em_worker/base_worker"
  autoload :BinParser, "em_worker/binary_parser"
  autoload :EmMaster, "em_worker/em_master"
  autoload :Helper, "em_worker/em_worker_helper"
  autoload :Log, "em_worker/em_log"
  autoload :Config, "em_worker/em_worker_config"
  autoload :CronTrigger, "em_worker/cron_trigger"
end
