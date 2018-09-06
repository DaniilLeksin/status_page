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
  			max_size: 1
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
    configuration_path = path.nil? ? File.join(Dir.pwd, @configuration[:configuration][:output_folder], Time.now.strftime('%s').to_s) : path
    
    # Manage MAX file size from configuration file,
    output_file = File.new(configuration_path, 'a')
    if ((output_file.size + data.size) / 2**20).round(2) > @configuration[:configuration][:max_size]
      timestamp = Time.now.strftime('%s').to_s
      base_name = File.basename(configuration_path)
      new_path = "copy_#{timestamp}_#{base_name}"
      # Save full file as a copy with the new name
      FileUtils.cp(path, new_path)
      # Clear the file
      File.truncate(configuration_path, 0)
    end

    output_file = File.new(configuration_path, 'a')
    output_file.puts(data)
    # TODO: Add logging
  end
end