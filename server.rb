require 'rubygems'
require 'sinatra'
require 'haml'
require 'aws/s3'

get '/' do
  haml :index
end

get '/images' do
  AWS::S3::Base.establish_connection!(
    :access_key_id     => ENV['S3_KEY'],
    :secret_access_key => ENV['S3_SECRET']
  )
  
  @images = AWS::S3::Bucket.objects('photobooth.heroku.com')
  
  haml :images
end

post '/save' do
  result = "success"
  
  begin
    AWS::S3::Base.establish_connection!(
      :access_key_id     => ENV['S3_KEY'],
      :secret_access_key => ENV['S3_SECRET']
    )
    
    AWS::S3::S3Object.store(
      "#{Time.now.to_i}.png",
      File.open(request.body.path),
      "photobooth.heroku.com"
    )
  rescue => e
    result = "failure (#{e})"
  end
  
  result
end