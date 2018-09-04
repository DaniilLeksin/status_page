#!/usr/bin/env ruby

require 'thor'
require_relative 'responseHandler'


class StatusPage < Thor
  # TODO: comment here!
  desc 'test method', 'a test greeting task'

  # Test method to check script functionality
  def test_me
    'Hi! Here is the place for the nice code!'
  end

  desc 'open URI method', 'return URI response'
  def openUri(uri)
  	r = ResponseHandler.new
  	p r.openUri(uri)
  end
end

StatusPage.start(ARGV)
