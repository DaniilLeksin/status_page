require 'benchmark'
require 'open-uri'
require 'json'

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
    rescue OpenURI::HTTPError => error
      status = error.io.status
    rescue SocketError => error
      status = ["443", "Bad URI"]
    end
    result = {:data => response, :status => status, :total_time => time ? time.total : nil}
  end
end
