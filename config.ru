require 'rubygems'
require './thread-dumper'

require 'bundler'
Bundler.require

require './app.rb'
run Sinatra::Application
