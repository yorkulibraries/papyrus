set :stage, :production
set :rails_env, :production

server 'papyrus.your-server.com', user:"#{fetch(:user)}", roles: %w{web app db}, primary: true

set :deploy_to, "/var/www/html/#{fetch(:application)}"


# setup rbenv.
set :rbenv_type, :system
set :rbenv_ruby, '2.1.2'
set :rbenv_path, '~/.rbenv'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}


#before  'deploy:assets:precompile', 'deploy:migrate'
