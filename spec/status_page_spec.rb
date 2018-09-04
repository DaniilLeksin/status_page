require 'spec_helper'
require_relative '../bin/status-page'

describe '#test_me' do
  it 'should return greeting text' do
    expect(StatusPage.start(%w(test_me))).to eq 'Hi! Here is the place for the nice code!'
  end
end
