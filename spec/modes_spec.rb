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
end