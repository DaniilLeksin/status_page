require 'spec_helper'
require_relative '../bin/modes'

describe '#Modes' do
  before do
  	@modes = Modes.new
  end

  it 'should run PULL mode' do
  	# TODO: add test
  	@modes.pull
  end

  it 'should run LIVE mode' do
  	# TODO: add test
  	@modes.pull
  end

  it 'should run HISTORY mode' do
  	# TODO: add test
  	@modes.history
  end

   it 'should run Verbose mode' do
  	# TODO: add test
  	@modes.verbose
  end
end