require 'rubygems'
require './thread-dumper'

require 'bundler'
Bundler.require

#Our modular sinatra app class is in app.rb
require './app.rb'
#Now run the app.
run SinnerApp.new
