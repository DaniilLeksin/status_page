require 'spec_helper'
require_relative '../bin/responseHandler'

describe '#openUri' do
  before do
  	@response_handler = ResponseHandler.new
  end

  it 'should return SocketError whan request bad URI' do
  	uri = 'https://badUri'
  	rh = @response_handler.openUri(uri)
  	expect(rh).to have_key(:status)
  	expect(rh).to have_key(:data)
  	expect(rh[:data]).to be_empty
  	expect(rh[:total_time]).to be_nil
  	expect(rh[:status]).not_to be_empty
  	expect(rh[:status]).to match_array(["443", "Bad URI"])
  end

  it 'should return HTTP Error' do
  	uri = 'https://httpstat.us/504'
  	rh = @response_handler.openUri(uri)
  	expect(rh).to have_key(:status)
  	expect(rh).to have_key(:data)
  	expect(rh[:data]).to be_empty
  	expect(rh[:total_time]).to be_nil
  	expect(rh[:status]).not_to be_empty
  	expect(rh[:status]).not_to match_array(["200", "OK"])
  end

  it 'should return openUri JSON data' do
  	uri = 'https://status.github.com/api/status.json'
  	rh = @response_handler.openUri(uri)
  	expect(rh).to have_key(:status)
  	expect(rh).to have_key(:data)
  	expect(rh[:data]).not_to be_empty
  	expect(rh[:status]).not_to be_empty
  	expect(rh[:total_time]).not_to be_nil
  	expect(rh[:status]).to match_array(["200", "OK"])
  end

  it 'should parse response with the fields' do
    # TODO: add test here
  end
end

