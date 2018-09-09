require 'spec_helper'
require_relative '../bin/inputOutputHandler'

describe '#InputOutputHandler' do
  before do
  	@io = InputOutputHandler.new
  end

  it 'should create configuration YAML file with default data' do
    # TODO: dig how to test it :)
  	@io.createConfigurationData()
  end

  it 'should load data from configuration YAML' do
    # TODO: dig how to test it :)
  	@io.loadConfigurationData()
  end

  it 'should load list of services' do
    # TODO: dig how to test it :)
  	@io.loadServiceList()
  end

  it 'should update configurations' do
    # TODO: dig how to test it :)
  	conf = @io.loadConfigurationData()
  	conf[:configuration][:service_list] = 'data/updated_services.csv'
  	@io.updateConfiguration(conf)
  	@io.loadServiceList()
  end

  it 'should store output data in new file' do
  	#storeOutputData	
  end

  it 'should add data to existing output file' do
  	#storeOutputData
  end
  
end
