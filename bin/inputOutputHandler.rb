require 'yaml'
require 'csv'

class InputOutputHandler
  def initialize
    raise "No Configuration file" unless File.exist?(File.join(Dir.pwd, 'configuration.yml'))
    @configuration = loadConfigurationData
  end

  def updateConfiguration(configuration)
    @configuration = configuration
  end

  def createConfigurationData
  	default_configuration = {
  		timestamp: Time.now.strftime('%s'),
  		configuration: {
  			service_list: 'data/services.csv',
  			output_folder: 'output/',
        last_updated: '',
        error_output: '',
  			fill: false,
  			max_size: 4096
  		}
  	}

  	File.open("configuration.yml", "w") { |file| file.write(default_configuration.to_yaml) }
  end

  def loadConfigurationData(path=nil)
  	configuration_path = path.nil? ? File.join(Dir.pwd, 'configuration.yml') : path
  	YAML.load(File.read(configuration_path))
  end

  def loadServiceList(path=nil)
    configuration_path = path.nil? ? File.join(Dir.pwd, @configuration[:configuration][:service_list]) : path
    CSV.read(configuration_path)
  end

  def storeOutputData(data, path=nil)
    # TODO: manage to add to last updated file
    configuration_path = path.nil? ? File.join(Dir.pwd, @configuration[:configuration][:output_folder], Time.now.strftime('%s').to_s) : path
    output_file = File.new(configuration_path, 'a')
    output_file.puts(data)
  end
end