require 'rubygems'
require 'sinatra'
require 'haml'

get '/' do
  haml :index
end

get '/images' do
  @images = Dir.glob("public/images/*.png")
  
  haml :images
end

post '/save' do
  result = "success"
  
  begin
    FileUtils.copy_file(request.body.path, "public/images/yo_#{Time.now.to_i}.png")
  rescue
    result = "failure"
  end
  
  result
end