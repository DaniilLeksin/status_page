require 'spec_helper'
require_relative '../bin/modes'
require_relative '../bin/inputOutputHandler'

# TODO: need to move output_test folder!
describe '#Modes' do
  before do
    @modes = Modes.new
    @io = InputOutputHandler.new
  end

  context 'PULL mode' do
    it 'should run PULL and create a file with response data' do
      configuration = @io.loadConfigurationData
      output_path = configuration[:configuration][:output_folder] 
      files_before = []
      files_after = []
      Dir.foreach(File.join(Dir.pwd, output_path)) do |item|
        next if item == '.' || item == '..' || File.directory?(item)
        files_before << item
      end
      # Run PULL
      @modes.pull
      Dir.foreach(File.join(Dir.pwd, output_path)) do |item|
          next if item == '.' || item == '..' || File.directory?(item)
          files_after << item
        end
      expect(files_after.count).to eq(files_before.count + 1)
    end

    it 'should run PULL with defined path and save data' do
      configuration = @io.loadConfigurationData
      output_path = configuration[:configuration][:output_folder]   
      path = File.join(Dir.pwd, output_path, 'rspec_test_pull.txt')
      @modes.pull(path)
      expect(File.exist?(path)).to be_truthy
      FileUtils.rm(path)
    end
  end

  context 'LIVE mode' do
    it 'should run LIVE mode' do
      # TODO: dig how to test it :)
      # @modes.pull
    end
  end

  context 'HISTORY mode' do
    it 'should run LIVE mode' do
      # TODO: dig how to test it :)
      # @modes.history
    end
  end
end