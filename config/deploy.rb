require 'capistrano/ext/multistage'
#require 'hipchat/capistrano'
# require 'bundler/capistrano'
# require 'delayed/recipes'

# TODO: rake db:schema:load on cold deploy

Dir.glob("#{ File.join(File.dirname(__FILE__),'..','lib','recipes') }/*.rb").each {|f| require(f) }

set :stages, ['production','staging']
set :default_stage, 'staging'
set :branch, fetch(:branch, "master")

set :application, 'video-server'
set :repository, "git@github.com:stevekane/video-server.git"
set :ssh_options, { :forward_agent => true }
set :deploy_via, :remote_cache
#set :assets_role, :app

before "deploy:assets:precompile", "sym_link:database"
before "deploy:assets:precompile", "sym_link:settings"
before "deploy:assets:precompile", "sym_link:logs"

before "deploy:restart", "db:migrate"

after "deploy:update_code", "bundle:install"

namespace :bundle do
  desc 'bundle install'
  task :install do
    run "cd #{current_release} && bundle install"
  end
end

namespace :db do
  desc 'rake db:migrate'
  task :migrate do
    run "cd #{current_release} && bundle exec rake db:migrate RAILS_ENV=#{stage}"
  end
end

namespace :delayed_job do
  task :restart do
    begin
      run "cd #{current_release}; script/delayed_job stop -- production"
    rescue
      puts "Failed to stop delayed_job (is it running?)"
    end
    puts "Starting delayed jobs"
    run "cd #{current_release}; script/delayed_job start -- production"
  end
end

namespace :sym_link do
  desc 'sym link database.yml'
  task :database do
    run "cd #{current_release}/config && ln -sf #{deploy_to}/shared/private/config/database.yml database.yml"
  end

  desc 'sym link production logs'
  task :logs do
    run "cd #{current_release} && rm -rf log && ln -s #{deploy_to}/shared/log log"
  end

  desc 'sym link settings file'
  task :settings do
    run "cd #{current_release}/config && ln -sf #{deploy_to}/shared/private/config/settings.yml settings.yml"
  end
end

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end
