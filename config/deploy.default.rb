require "bundler/capistrano"

set :application, "papyrus"
set :user, "your-user"
set :deploy_to, "/apps/#{application}"
set :deploy_via, :remote_cache
set :use_sudo, false

set :scm, :git
set :repository,  "git@github.com:yorkulcs/papyrus.git"
set :branch, "master"

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

after "deploy", "deploy:cleanup" # keep only the last 5 releases


# two stages
task :production do
  set :deploy_to, "/apps/#{application}"
  server "yourservername.com", :web, :app, :db, primary: true 
end

task :dev do
  set :deploy_to, "/apps/#{application}"
  server "dev.yourservername.com", :web, :app, :db, primary: true    
end



namespace :deploy do
  %w[start stop restart].each do |command|
     desc "Restart #{application} passenger instance. All commands execute the same thing"
     task command, roles: :app, except: {no_release: true} do
        run "touch #{deploy_to}/current/tmp/restart.txt"
     end
   end
  
   task :setup_config, roles: :app do
     run "mkdir -p /apps/#{application}"
     run "ln -nfs #{current_path}/public /var/www/html/#{application}"        
   end
   before "deploy:setup", "deploy:setup_config"
    
  
   task :setup_relative_ralis_root do
     set :asset_env, "RAILS_GROUPS=assets RAILS_RELATIVE_URL_ROOT=\"/#{application}\""
   end
   before "deploy:assets:precompile", "deploy:setup_relative_ralis_root"
  
  
  ### CUSTOM TASKS FOR DEPLOY PROCESS            
  task :symlink_datastore, :roles => :app do
    run <<-CMD    
      umask 002 &&  
      rm -rf #{current_path}/public/uploads &&
      ln -nfs /data/#{application} #{current_path}/public/uploads
    CMD
  end
  after "deploy:restart", "deploy:symlink_datastore"


end