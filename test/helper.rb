require_relative 'support/apiweir'
require_relative 'support/http_server'

require 'test/unit'
require 'etc'

Thread.abort_on_exception = true

class Test::Unit::TestCase

  def cpu_cores
    Etc.nprocessors
  end

  def bg_run_http_server_web1
    http_server = HTTPServer::Web1.new
    http_server.thread_run
    return http_server.port
  end

end
