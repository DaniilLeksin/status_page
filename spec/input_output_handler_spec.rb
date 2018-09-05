require 'spec_helper'
require_relative '../bin/inputOutputHandler'

describe '#InputOutputHandler' do
  before do
  	@io = InputOutputHandler.new
  end

  it 'should create configuration YAML file with default data' do
  	@io.createConfigurationData()
  end

  it 'should load data from configuration YAML' do
  	@io.loadConfigurationData()
  end

  it 'should load list of services' do
  	@io.loadServiceList()
  end

  it 'should update configurations' do
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
