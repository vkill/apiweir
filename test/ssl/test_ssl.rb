require_relative '../helper'

class SSLTest < Test::Unit::TestCase
  attr_accessor :port_web1

  def setup
    self.port_web1 = bg_run_http_server_web1
    bg_run_apiweir
  end

  def teardown
    # TODO
  end

  def test_match
  end
end
