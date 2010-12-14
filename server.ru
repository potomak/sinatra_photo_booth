use Rack::Static, :urls => ['com', 'swfobject.js']

class Server
  def call(env)
    status = 200
    header = { 'Content-Type' => 'text/html', 'Cache-Control' => 'public, max-age=86400' }
    content = File.open('index.html', File::RDONLY)
    
    [status, header, content]
  end
end

run Server.new