require 'yaml'
require 'csv'
require 'fileutils'
require_relative 'displayHandler'
require_relative 'errorsHandler'

class InputOutputHandler
  def initialize
    @display = DisplayHandler.new
    # raise "No Configuration file!!" unless File.exist?(File.join(Dir.pwd, 'configuration.yml'))
    @configuration = loadConfigurationData
    
    # Create output folders structure:
    # ..
    # - output/
    #     -- history/
    #     -- trash/
    # ..
    createFolder(File.join(Dir.pwd, @configuration[:configuration][:output_folder]))
    createFolder(File.join(Dir.pwd, @configuration[:configuration][:history_folder]))
    createFolder(File.join(Dir.pwd, @configuration[:configuration][:trash_folder]))
    # commented for beckup task
    # createFolder(File.join(Dir.pwd, @configuration[:configuration][:backup_folder]))
  rescue => error 
    @display.shortLine("#{error.class}. Message: #{error.message}", "ERROR")
    exit
  end

  def createFolder(path)
    Dir.exist?(path) ? true : Dir.mkdir(path)
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
        history_folder: 'output/history/',
        trash_folder: 'output/trash/',
        backup_folder: 'output/backup/', # set FFU
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

  def storeHistory(path, verbose)
    output_folder = File.join(Dir.pwd, @configuration[:configuration][:output_folder])
    out_folder = @configuration[:configuration][:history_folder]
    Dir.foreach(output_folder) do |item|
      file_name = File.join(output_folder, item)
      next if item == '.' or item == '..' or File.directory?(file_name)
      data = []
      File.open(file_name) do |file|
        @display.shortLine("=Name: #{item}. Size: #{file.size} bytes", nil, verbose)
        file.each_line do |line|
          storeOutputData(line, path, out_folder)
          data << line.chomp.split(' | ')
        end
      end
      # Move file to trash folder
      FileUtils.mv(file_name, File.join(Dir.pwd, @configuration[:configuration][:trash_folder], item))
      @display.tableView(data, '%-5s %-25s %-25s %-10s %-25s %s', ['#', 'Time Start', 'Name', 'Status', 'Last Update', 'Response Time'], verbose)
    end
  rescue => error 
    @display.shortLine("#{error.class}. Message: #{error.message}", "ERROR")
    exit
  end

  # TODO: this method is not implemented
  # Case: to use `storeDirectory` for store History,
  # because it has the same logic
  # Set it here FFU
  def storeDirectory(path, verbose, backup)
    history_path = File.join(Dir.pwd, @configuration[:configuration][:history_folder])
    backup_folder = @configuration[:configuration][:backup_folder]
    Dir.foreach(history_path) do |item|
      file_name = File.join(history_path, item)
      next if item == '.' or item == '..' or File.directory?(file_name)
      data = File.read(file_name)
      # TODO: Add sperator logic
      # TODO: comment while call it twice
      storeOutputData(data, path, backup_folder)
      # Clear history
      FileUtils.rm(file_name)
      # TODO: logging
    end
  end

  def storeOutputData(data, path, out_folder)
    configuration_path = path.nil? ? File.join(Dir.pwd, out_folder, Time.now.strftime('%s').to_s) : path
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
  rescue => error
    @display.shortLine("#{error.class}. Message: #{error.message}", "ERROR")
    exit
  end
end