require 'benchmark'
require 'open-uri'
require 'json'
require 'csv'

# TODO: comment here!
class ResponseHandler

  def openUri(uri)
    status = []
    buffer = ''
    response = ''
    begin
      time = Benchmark.measure do
          buffer = open(uri)
      end
      status = buffer.status
      response = JSON.parse(buffer.read)
    # Manage Errors
    rescue OpenURI::HTTPError => error
      status = error.io.status
    rescue SocketError => error
      status = ["443", "Bad URI"]
    end
    result = {data: response, status: status, total_time: time ? time.total.round(2) : nil}
  end

  def search_hash(hash, key)
    return hash[key] if hash.assoc(key)
    hash.delete_if{|key, value| value.class != Hash}
    new_hash = Hash.new
    hash.each_value {|values| new_hash.merge!(values)}
    unless new_hash.empty?
      search_hash(new_hash, key)
    end
  end

  def parseResponse(response, rule, keys)
    # Convert rule [none=up;minor=minor;major=major] to array ["none=up","minor=minor","major=major"]
    rule_arr = CSV.parse(rule.gsub!(';', ',').gsub!('[','').gsub!(']','')).flatten
    # Convert none=up,minor=minor,major=major to hash {"none"=>"up", "minor"=>"minor", "major"=>"major"}
    rule_hash = Hash[ *rule_arr.collect { |v| [ v.split('=')[0], v.split('=')[1] ] }.flatten ]

    # First two keys in CSV file must be for current_status, last_updated
    status = search_hash(response, keys[0])
    last_update = search_hash(response, keys[1])
    #TODO: pave the way to manage other keys (to think about uniqueness)

    # Format the status, if service status is 'good/none/green' format it to 'up'
    formated_status = rule_hash.has_key?(status) ? rule_hash[status] : nil

    return formated_status, last_update
  end
end
