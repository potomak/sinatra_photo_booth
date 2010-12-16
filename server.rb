require 'rubygems'
require 'sinatra'

get '/' do
  redirect '/index.html'
end

post '/save' do
  # puts "save POST request"
  # puts request.body
  # puts request.body.inspect
  
  result = "success"
  
  begin
    FileUtils.copy_file(request.body.path, "public/images/yo_#{Time.now.to_i}.png")
  rescue
    result = "failure"
  end
  
  result
end