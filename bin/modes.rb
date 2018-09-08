require_relative 'responseHandler'
require_relative 'inputOutputHandler'
require 'fileutils'

class Modes
  def pull(path=nil)
  	result = ""
  	timestamp = Time.now
  	io = InputOutputHandler.new
  	response_handler = ResponseHandler.new
  	configuration = io.loadConfigurationData
    # services_arr stores the data from service.csv file in the format
    # Service Name | API Endpoint | Rules | Keys
    # Rules: condition to replace not standart status key to a single (You can specify any)
    # Ex. Status UP is 'none' in bitbacket, green' in github
    # Keys: hash keys in service response where status/updated_at values are.
  	services_arr = io.loadServiceList
  	services_arr.each do |service_data|
  	  service_name = service_data[0]
  	  api_endpoint = service_data[1]
  	  rule = service_data[2]
  	  keys = service_data[3, service_data.count - 1]
  	  # Get Request
  	  response = response_handler.openUri(api_endpoint)
      # `total_time` is a response time (FFU)
  	  total_time = response[:total_time]

  	  status, last_update = response_handler.parseResponse(response, rule, keys)
  	  # Generate output result in format:
  	  # Check Time | Service Name | Current Status | Service Updated Time | Request Time
  	  service_status_info = [timestamp, service_name, status, last_update, total_time].map { |k| "#{k}" }.join(" | ") + "\n"
  	  result << service_status_info
  	end
  	io.storeOutputData(result, path)
  end

  def live(timeout, output)
    # PARAM: output should be defined to distinguish periodic responses
    # PARAM: timeout determines pause after requestion list of services
    # Make it to start periodically
    # sleep(timeout) until self.pull(output)
    exit_requested = false
    Kernel.trap( "INT" ) { exit_requested = true }
    while !exit_requested
      self.pull(output)
      sleep timeout.to_i
    end
    # TODO:Logging
  end

  def history(path)
    io = InputOutputHandler.new
    io.storeHistory(path)
  end

  def backup(path=nil)
  end

  def restore(path=nil)
  end
end