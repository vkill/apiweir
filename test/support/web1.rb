require 'webrick'

server = WEBrick::HTTPServer.new Port: ENV.fetch('PORT', 0), BindAddress: '127.0.0.1'

server.mount_proc '/' do |req, res|
  res.body = "#{req.request_uri.path}"
end

trap 'INT' do server.shutdown end

port = server.listeners.first.addr[1]

server.start
