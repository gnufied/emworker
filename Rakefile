require 'rubygems'
require 'rake'
require 'rake/clean'
require 'rake/gempackagetask'
require 'rake/rdoctask'
require 'rake/testtask'
require 'spec/rake/spectask'
require 'fileutils'

def __DIR__
  File.dirname(__FILE__)
end
include FileUtils

NAME = "em_worker"
$LOAD_PATH.unshift __DIR__+'/lib'
require 'em_worker'

CLEAN.include ['**/.*.sw?', '*.gem', '.config','*.rbc']
Dir["tasks/**/*.rake"].each { |rake| load rake }


@windows = (PLATFORM =~ /win32/)

SUDO = @windows ? "" : (ENV["SUDO_COMMAND"] || "sudo")


desc "Packages up EmWorker."
task :default => [:package]

task :doc => [:rdoc]

spec = Gem::Specification.new do |s|
  s.name = NAME
  s.version = EmWorker::VERSION
  s.platform = Gem::Platform::RUBY
  # FIXME: disable RDoc for the time being
  #s.has_rdoc = true
  #s.extra_rdoc_files = [""]
  #s.rdoc_options += RDOC_OPTS +
  #  ['--exclude', '^(app|uploads)']
  s.summary = "EmWorker, A BackgrounDRb clone on top of EventMachine"
  s.description = s.summary
  s.author = "Hemant Kumar"
  s.email = 'mail@gnufied.org'
  s.homepage = 'http://github.com/gnufied/'
  s.required_ruby_version = '>= 1.8.5'
  s.files = %w(Rakefile) + Dir.glob("{test,lib,config}/**/*")
  s.require_path = "lib"
  s.bindir = "bin"
  s.executables = "em_runner"
end

Rake::GemPackageTask.new(spec) do |p|
  #p.need_tar = true
  p.gem_spec = spec
end

task :install do
  sh %{rake package}
  sh %{#{SUDO} gem install pkg/#{NAME}-#{EmWorker::VERSION} --no-rdoc --no-ri}
end

task :uninstall => [:clean] do
  sh %{#{SUDO} gem uninstall #{NAME}}
end

desc "Converts a YAML file into a test/spec skeleton"
task :yaml_to_spec do
  require 'yaml'

  puts YAML.load_file(ENV['FILE']||!puts("Pass in FILE argument.")&&exit).inject(''){|t,(c,s)|
    t+(s ?%.context "#{c}" do.+s.map{|d|%.\n  xspecify "#{d}" do\n  end\n.}*''+"end\n\n":'')
  }.strip
end

