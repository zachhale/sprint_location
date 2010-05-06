#!/usr/bin/env ruby

require 'rubygems'
require 'sprint'
require 'yaml'

config = YAML.load_file(File.join(File.dirname(__FILE__), "config.yml"))

s = Sprint.new(config['sprint'])
puts s.fourg