# Creating a Sinatra based Ruby app on redhats OpenShift PaaS #

## Prerequisites ##

1. Sign up for an account at [OpenShift](http://www.openshift.com)
2. Edit your account info to add a SSH Public Key (openssh format) and to setup a "private" namespace (This way if you create appname, then it would become appname-namespace.rhcloud.com)
3. Setup any temp auth tokens (if needed, I did'nt)
4. Ruby 1.9.x is preferred. Install the rhc gem ("gem install rhc"), Make sure you have git.
5. Run "rhc setup" from the command line.


## Create a new app ##

1. From the browser, create a new app (e.g. sinner) that uses Ruby 1.9 cartridge.
2. This will get you a Git path like "ssh://someid@sinner-yournamespace.rhcloud.com/~/git/sinner.git/"
3. Git clone from this path to your local machine.
4. This may come with a standard config.ru - I moved that to config.ru.unused
5. Added web.rb, config.ru, Gemfile etc and ran "bundle install".
6. You can locally run "ruby app.rb" to test if your app works locally. And then push it to openshift via "git push"
7. You can tail logs from the app using "rhc tail <apname>"

