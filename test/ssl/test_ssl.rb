require_relative '../helper'

class SSLTest < Test::Unit::TestCase
  attr_accessor :port_web1
  attr_accessor :prefix_path_apiweir

  def setup
    self.port_web1 = bg_run_http_server_web1
    self.prefix_path_apiweir = bg_run_apiweir(9080)
  end

  def teardown
    kill_bg_run_apiweir(prefix_path_apiweir)
  end

  def test_match
  end
end
