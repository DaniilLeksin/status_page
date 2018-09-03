#!/usr/bin/env ruby

require 'thor'

class StatusPage < Thor
  desc "test method", "a test greeting task"
  def test_me
  	p 'Hi! Here is the place for the nice code!'
  end
end

StatusPage.start(ARGV)