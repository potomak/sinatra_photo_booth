require 'rubygems'
require 'sinatra'

get '/' do
  redirect '/index.html'
end

post '/save' do
  puts "save POST request"
  puts request.body
  puts request.body.inspect
  
  FileUtils.copy_file(request.body.path, "public/images/yo_#{Time.now.to_i}.png")
end