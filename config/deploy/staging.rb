require 'rvm/capistrano'

server '162.243.73.207', :app, :web, :db, :primary => true
set :user, 'deploy'
set :deploy_to, '/home/deploy/rails_apps/staging.appsbyrequest.com'
set :use_sudo, false
set :rails_env, "staging"

load 'deploy/assets'
