require_relative 'support/http_server'

require 'test/unit'
require 'etc'
require 'tmpdir'
require 'fileutils'
require 'open3'

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

  def bg_run_apiweir
    Dir.mktmpdir('apiweir-') do |prefix_path|
      FileUtils.mkdir_p(File.join(prefix_path, 'config'))
      FileUtils.mkdir_p(File.join(prefix_path, 'logs'))
      FileUtils.cp(File.expand_path('../../conf/nginx.conf', __FILE__), File.join(prefix_path, 'config'))

      thr = Thread.new {
        cmd = "openresty -p #{prefix_path} -g 'daemon off;'"
        Open3.popen3(cmd) do |stdin, stdout, stderr, wait_thr|
          pid = wait_thr.pid
          p pid

          stdin.close

          p stdout.read
          stdout.close
          p stderr.read
          stderr.close

          Process.kill("SIGINT", wait_thr.pid)

          exit_status = wait_thr.value
          p exit_status

          unless exit_status.success?
            raise "run apiweir failed"
          end
        end
      }
      thr.join(3)
    end
  end

end
