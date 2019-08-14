require 'webrick'

module HTTPServer

  class Basic
    attr_accessor :server

    def thread_run
      Thread.start {
        trap 'INT' do server.shutdown end
        server.start
      }
    end

    def port
      server.listeners.first.addr[1]
    end
  end

  class Web1 < Basic
    def initialize(port = 0)
      server = WEBrick::HTTPServer.new Port: port, BindAddress: '127.0.0.1'

      server.mount_proc '/' do |req, res|
        res.body = "#{req.request_uri.path}"
      end

      self.server = server
    end
  end

  class Web2 < Basic
    def initialize(port = 0)
      server = WEBrick::HTTPServer.new Port: port, BindAddress: '127.0.0.1'

      server.mount_proc '/' do |req, res|
        res.body = "#{req.request_uri.path}"
      end

      server.mount_proc '/v1' do |req, res|
        res.body = "#{req.request_uri.path}"
      end

      self.server = server
    end
  end

  class Web2New < Basic
    def initialize(port = 0)
      server = WEBrick::HTTPServer.new Port: port, BindAddress: '127.0.0.1'

      server.mount_proc '/v1' do |req, res|
        res.body = "#{req.request_uri.path}"
      end

      server.mount_proc '/v2' do |req, res|
        res.body = "#{req.request_uri.path}"
      end

      self.server = server
    end
  end
end
