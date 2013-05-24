# also allow app to be run locally before pushing to openshift.
require 'rubygems'

require 'sinatra/base'
require 'ohai'
require 'json'
class SinnerApp < Sinatra::Base

  configure do
    set :logging, false 
  end
  get '/' do
    return wrap("<h2>This is a Sinatra test app running on OpenShift</h2><br> Click here for your <a href=\"/ua\">UA/IP info</a>.<br>Click here for <a href=\"/ohai/summary\">Ohai summary</a> and <a href=\"/ohai/full\">Ohai details</a><br>")
  end

  get '/ua' do
    wrap("<h2>Your browser: #{request.user_agent}</h2><h2>Your (internet) IP address: #{request.ip}</h2>")
  end

  get '/ohai/full' do
    content_type :json
    return getfromOhai.to_json
  end 

  get '/ohai/summary' do
  sysdata=getfromOhai
  if sysdata.nil?
    wrap("<h2>Could not fetch info using Ohai!<h2>")
  end
  #Find "guest" users... i.e. non-system/redhat users.
  langs=Array.new
  sysdata['languages'].keys.sort.each do |x|
    langs.push([x , sysdata['languages'][x]['version'] ])
  end
  guests=0
  sysdata['etc']['passwd'].keys.sort.each do |userx|
    guests+=1 if sysdata['etc']['passwd'][userx]['gecos'] =~ /OpenShift guest/    
  end
  wheels=sysdata['etc']['group']['wheel']['members'].length
  mem=sysdata.has_key?('memory') && sysdata['memory'].has_key?('total') ? sysdata['memory']['total'] : "Not available"
  cpu=sysdata.has_key?('cpu') ? (sysdata['cpu']['total'].to_s + "x #{sysdata['cpu']['0']['model_name']}") : "Not available" 
  ec2info="Dont think this is a EC2 instance"
  if sysdata.has_key?('ec2') && sysdata['ec2'].keys.length>0
    ec2info="EC2 instance type #{sysdata['ec2']['instance_type']} (AMI #{sysdata['ec2']['ami_id']}) in AZ #{sysdata['ec2']['placement_availability_zone']}
    "
  end

  return wrap(gentab({"OpenShift Guest users"=>guests, "#Users in wheel group(RH admins)"=>wheels, "Memory" => mem, "CPU" => cpu,"EC2 info"=> ec2info}) ) 
  end

  def gentab(x=Hash.new)
  t="<h2>Summary from Ohai</h2><br><table><border=1>"
  x.keys.sort.each do |item|
    t+="<tr><td><b>#{item}</b></td><td>#{x[item]}</td></tr>"
  end 
  return t + "</table><br><hr>Full Ohai (json) at <a href=\"/ohai/full\">Ohai details</a>"
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
    return JSON.parse(thissys.to_json)
  end

run! if app_file == $0
end
