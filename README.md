#Sinatra Photo Booth

You can't save pictures on the [demo](http://photobooth.heroku.com/) at Heroku because of their application constraints (see: [http://docs.heroku.com/constraints](http://docs.heroku.com/constraints))

##TODO

* write documentation
  1. flash external interface
  1. getting started
* <del>add alternative content if flash is missing</del>
* add alternative content if webcam is missing
* upload using AWS S3 (it should work also on Heroku)

## Start server

To start the server:

    $ ruby server.rb