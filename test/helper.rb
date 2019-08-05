require_relative 'support/run_apiweir'
require_relative 'support/run_web1'
require_relative 'support/run_web2'

require 'test/unit'
require 'etc'

class Test::Unit::TestCase
  def cpu_cores
    Etc.nprocessors
  end
end
