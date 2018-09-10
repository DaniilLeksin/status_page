require_relative 'responseHandler'
require_relative 'inputOutputHandler'
require_relative 'displayHandler'
require 'fileutils'

class Modes
  def initialize
    @io = InputOutputHandler.new
    @response_handler = ResponseHandler.new
    @display = DisplayHandler.new
    @configuration = @io.loadConfigurationData
  end

  def pull(path=nil)
    # services_arr stores the data from service.csv file in the format
    # Service Name | API Endpoint | Rules | Keys
    # Rules: condition to replace not standart status key to a single (You can specify any)
    # Ex. Status UP is 'none' in bitbacket, green' in github
    # Keys: hash keys in service response where status/updated_at values are.
    result = ""
    timestamp = Time.now
    services_arr = @io.loadServiceList
    services_arr.each do |service_data|
      service_name = service_data[0]
      api_endpoint = service_data[1]
      rule = service_data[2]
      keys = service_data[3, service_data.count - 1]
      # Get Request
      response = @response_handler.openUri(api_endpoint)
      # `total_time` is a response time (FFU)
      total_time = response[:total_time]

      status, last_update = @response_handler.parseResponse(response, rule, keys)
      # Generate output result in format:
      # Check Time | Service Name | Current Status | Service Updated Time | Request Time
      service_status_info = [timestamp, service_name, status, last_update, total_time].map { |k| "#{k}" }.join(" | ") + "\n"
      result << service_status_info
    end
    @io.storeOutputData(result, path, @configuration[:configuration][:output_folder])
    @display.shortLine("#{Time.now.strftime('%s').to_s}: Data saved!", "DONE")
  end

  def live(timeout, output)
    exit_requested = false
    Kernel.trap( "INT" ) { exit_requested = true }
    while !exit_requested
      @display.shortLine("#{Time.now.strftime('%s').to_s}: Request sent", "DONE")
      self.pull(output)
      @display.shortLine("#{Time.now.strftime('%s').to_s}: Data saved! Sleep for #{timeout} sec.", "DONE")
      sleep timeout.to_i
    end
  end

  def history(path, verbose)
    @io.storeHistory(path, verbose)
    @display.shortLine("#{Time.now.strftime('%s').to_s}: History merged.", "DONE")
  end

  def backup(path, verbose)
    # @io.storeHistory(path, @configuration[:configuration][:history_folder], false)
    # @io.storeDirectory(path, verbose, true)
  end

  def restore(path); end
end