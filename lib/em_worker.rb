dir = File.dirname(__FILE__)
$:.unshift(dir) unless $:.include?(dir)
require "rubygems"
require "eventmachine"

module EmWorker
  VERSION = "0.0.1"
  autoload :Runner, "em_worker/runner"
  autoload :BaseWorker, "em_worker/base_worker"
  autoload :BinParser, "em_worker/binary_parser"
end
