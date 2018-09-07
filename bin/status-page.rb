#!/usr/bin/env ruby

require 'thor'
require_relative 'responseHandler'
require_relative 'inputOutputHandler'
require_relative 'modes'


class StatusPage < Thor
  # TODO: comment here!
  desc 'test method', 'a test greeting task'

  # Test method to check script functionality
  def test_me
    'Hi! Here is the place for the nice code!'
  end

  # desc 'test method', 'a test greeting task'
  # def loadConf(path=nil)
  # 	io = InputOutputHandler.new
  # 	conf = io.loadConfigurationData(path)
  # 	p conf
  # end

  # desc 'test method', 'a test greeting task'
  # def loadServ(path=nil)
  # 	io = InputOutputHandler.new
  # 	conf = io.loadServiceList(path)
  # end

  # desc 'test method', 'a test greeting task'
  # def storeData(data, path=nil)
  # 	io = InputOutputHandler.new
  # 	conf = io.storeOutputData(data, path)
  # end

  desc 'test method', 'a test greeting task'
  def pull
  	mode = Modes.new
  	mode.pull
  end

  # desc 'test method', 'a test greeting task'
  # def live(t, o)
  # 	mode = Modes.new
  # 	mode.live(t, o)
  # end

  desc 'test method', 'a test greeting task'
  def history(path=nil)
  	mode = Modes.new
  	mode.history
  end
  
end

StatusPage.start(ARGV)
