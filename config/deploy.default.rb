
# config valid only for Capistrano 3.1
lock '3.1.0'

# NOTE:
# You need to add your SSH public key to /home/git/.ssh/authorized_keys on the GIT server
# You will also need to add your SSH public key to /home/deployer/.ssh/authorized_keys
#
# Deployment will use SSH Agent Forwarding to pass your SSH key to the GIT server
# You need to allow agent forwarding on your desktop by adding these two
# lines to your .ssh/config
#   Host reserves.library.yorku.ca reserves.staging.library.yorku.ca
#     ForwardAgent yes
# You may have to make your key available to your SSH key agent by running: ssh-add

set :application, 'papyrus'
set :user, "your-user"
set :repo_url,"git@github.com:yorkulcs/papyrus.git"
set :branch, "master"
set :deploy_via, :copy
set :use_sudo, false
set :ssh_options, {:forward_agent => true}


set :log_level, :debug

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart
  after :restart, 'deploy:cleanup'

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

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
