require_relative 'support/http_server'

require 'test/unit'
require 'etc'
require 'tmpdir'
require 'fileutils'
require 'open3'
require 'socket'
require 'timeout'

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

  def bg_run_apiweir(port)
    prefix_path = Dir.mktmpdir('apiweir-')
    FileUtils.mkdir_p(File.join(prefix_path, 'conf'))
    FileUtils.mkdir_p(File.join(prefix_path, 'logs'))
    FileUtils.cp(File.expand_path('../../conf/nginx.conf', __FILE__), File.join(prefix_path, 'conf'))

    pid = fork do
      cmd = "openresty -p #{prefix_path} -c #{File.join(prefix_path, 'conf', 'nginx.conf')} -g 'daemon off;'"

      Open3.pipeline_start(cmd) do |ts|
        t = ts[0]

        running = false
        n = 0
        n_max = 3
        while n < n_max do
          begin
            Timeout::timeout(2) do
              begin
                TCPSocket.new('127.0.0.1', port).close
                running = true
                n = n_max
              rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH => ex
                sleep 1
                puts ex
                n += 1
              end
            end
          rescue Timeout::Error => ex
            puts ex
            n += 1
          end
        end

        if running
          Process.daemon(t.pid)
        else
          Process.kill('HUP', Process.ppid)
          Process.kill('QUIT', t.pid)
        end

      end
    end

    Signal.trap('HUP') {
      raise 'run apiweir failed'
    }

    Process.wait(pid)

    if $?.exitstatus != 0
      raise 'run apiweir failed'
    end

    return prefix_path
  end

  def kill_bg_run_apiweir(prefix_path)
    pid = open(File.join(prefix_path, 'logs', 'nginx.pid')).read.to_i
    if pid > 0
      Process.kill('QUIT', pid)
    end
  end
end
