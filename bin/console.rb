#!/usr/bin/env ruby

# frozen_string_literal: true


require_relative '../lib/cron_parser'
require 'irb/completion'
require 'irb'
P = CronParser::Parser.new('1 2 3 4 5 bin/blabla')
IRB.start(__FILE__)
