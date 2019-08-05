require 'webrick'

server = WEBrick::HTTPServer.new Port: ENV.fetch('PORT', 8000)

server.mount_proc '/' do |req, res|
  res.body = "#{req.request_uri.path}"
end

trap 'INT' do server.shutdown end

server.start
