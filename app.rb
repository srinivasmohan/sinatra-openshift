# also allow app to be run locally before pushing to openshift.
require 'rubygems'

require 'sinatra/base'
require 'ohai'
class SinnerApp < Sinatra::Base

  configure do
    set :logging, false 
  end
  get '/' do
    return wrap("<h2>This is a Sinatra test app running on OpenShift</h2><br> Click here for your <a href=\"/ua\">UA/IP info</a>.<br>Click here for <a href=\"/envinfo\">Ohai info</a><br>")
  end

  get '/ua' do
    wrap("<h2>Your browser: #{request.user_agent}</h2><h2>Your (internet) IP address: #{request.ip}</h2>")
  end

  get '/envinfo' do
    content_type :json
    return getfromOhai
  end 
  
  def wrap(msg=nil)
  html=<<HTML
<!doctype html>
<html lang="en">
<meta charset="utf-8">
<title>Sinatra test app on OpenShift</title>
 <style>
  html {
  background: black;
  }
  body {
    background: #333;
    background: -webkit-linear-gradient(top, black, #666);
    background: -o-linear-gradient(top, black, #666);
    background: -moz-linear-gradient(top, black, #666);
    background: linear-gradient(top, black, #666);
    color: white;
    font-family: "Helvetica Neue",Helvetica,"Liberation Sans",Arial,sans-serif;
    width: 40em;
    margin: 0 auto;
    padding: 3em;
  }
  a {
    color: white;
  }
  h2 {
    margin: 2em 0 .5em;
    border-bottom: 1px solid #999;
  }
  </style>
</head>
  <body>
    #{msg}
  </body>

  </html>
HTML
  return html
  end 

  def getfromOhai
    thissys=Ohai::System.new
    thissys.all_plugins
    return thissys.to_json
  end
  run! if app_file == $0
end
