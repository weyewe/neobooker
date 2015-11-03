require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/rbenv'  # for rbenv support. (http://rbenv.org)
require 'mina/unicorn'
# require 'mina/rvm'    # for rvm support. (http://rvm.io)
require 'mina/whenever'

# Basic settings:
#   domain       - The hostname to SSH to.
#   deploy_to    - Path to deploy into.
#   repository   - Git repo to clone from. (needed by mina/git)
#   branch       - Branch name to deploy. (needed by mina/git)
# https://github.com/weyewe/shopper-deployment.git
 

set :domain, '128.199.193.90'

puts "Gonna deploy in #{domain}"
set :deploy_to, '/var/www/booker.com'
# https://github.com/weyewe/esman.git
set :repository, 'git://github.com/weyewe/neobooker.git'
set :branch, 'master'
set :user , 'app_deploy'
set :unicorn_pid, "#{deploy_to}/shared/pids/unicorn.pid"

set :rbenv_path, "/usr/local/rbenv"


# For system-wide RVM install.
#   set :rvm_path, '/usr/local/rvm/bin/rvm'

# Manually create these paths in shared/ (eg: shared/config/database.yml) in your server.
# They will be linked in the 'deploy:link_shared_paths' step.
set :shared_paths, ['config/database.yml', 'log', 'config/secrets.yml', 'config/initializers/app_secrets.rb']

# Optional settings:
#   set :user, 'foobar'    # Username in the server to SSH to.
#   set :port, '30000'     # SSH port number.
#   set :forward_agent, true     # SSH forward_agent.

# This task is the environment that is loaded for most commands, such as
# `mina deploy` or `mina rake`.
task :environment do
  # If you're using rbenv, use this to load the rbenv environment.
  # Be sure to commit your .ruby-version or .rbenv-version to your repository.
  invoke :'rbenv:load'

  # For those using RVM, use this to load an RVM version@gemset.
  # invoke :'rvm:use[ruby-1.9.3-p125@default]'
end

# Put any custom mkdir's in here for when `mina setup` is ran.
# For Rails apps, we'll make some of the shared paths that are shared between
# all releases.
task :setup => :environment do

  # sudo mkdir -p "/var/www/booker.com" && sudo chown -R app_deploy "/var/www/booker.com"




  queue! %[mkdir -p "#{deploy_to}/shared/sockets"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/sockets"]

  queue! %[mkdir -p "#{deploy_to}/shared/log"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/log"]

  queue! %[mkdir -p "#{deploy_to}/shared/config"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/config"]

  queue! %[mkdir -p "#{deploy_to}/shared/config/initializers"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/config/initializers"]

  queue! %[touch "#{deploy_to}/shared/config/database.yml"]
  queue  %[echo "-----> Be sure to edit 'shared/config/database.yml'."]

  queue! %[touch "#{deploy_to}/shared/config/secrets.yml"]
  queue %[echo "-----> Be sure to edit 'shared/config/secrets.yml'."]

  queue! %[touch "#{deploy_to}/shared/config/initializers/app_secrets.rb"]
  queue %[echo "-----> Be sure to edit 'shared/config/initializers/app_secrets.rb'."]

  # sidekiq needs a place to store its pid file and log file
  queue! %[mkdir -p "#{deploy_to}/shared/pids/"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/pids"]

end

desc "Deploys the current version to the server."
task :deploy => :environment do
  to :before_hook do
    # Put things to run locally before ssh
  end
  deploy do
    # Put things that will set up an empty directory into a fully set-up
    # instance of your project.
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    # invoke :'rails:db_create'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'
    invoke :'deploy:cleanup'

    # to :launch do
    #   queue "restart shopper"
    # end

    # to :launch do
    #   queue "mkdir -p #{deploy_to}/#{current_path}/tmp/"
    #   queue "touch #{deploy_to}/#{current_path}/tmp/restart.txt"
    # end
    to :launch do
      invoke :'unicorn:restart'
      invoke :'whenever:update'
    end
  end
end

# namespace :unicorn do
#   task :restart do
    
#     queue %{
#       echo "-----> Restarting Unicorn"
#       #{echo_cmd %[kill -s USR2 `cat /tmp/unicorn.shopper.pid`]}
#     }
#   end
# end

# For help in making your deploy script, see the Mina documentation:
#
#  - http://nadarei.co/mina
#  - http://nadarei.co/mina/tasks
#  - http://nadarei.co/mina/settings
#  - http://nadarei.co/mina/helpers
