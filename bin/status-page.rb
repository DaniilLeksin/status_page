#!/usr/bin/env ruby

require 'thor'
require_relative 'responseHandler'
require_relative 'inputOutputHandler'


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
  
end

StatusPage.start(ARGV)
