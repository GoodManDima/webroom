# config valid only for Capistrano 3.1
lock '3.1.0'

set :application, 'webroom'

set :scm, :git
set :repo_url, 'git@github.com:GoodManDima/webroom.git'
set :branch, "master"

set :user, "dev1"
set :deploy_to, "/home/dev1/webroom.pro"

server 'webroom.pro', user: 'dev1', roles: %w{web app db}

set :rails_env, "production"
set :deploy_via, :remote_cashe

set :keep_releases, 5

namespace :deploy do
  # Рестарт Passenger
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end
  desc "Symlink storage folder"
  task :symlink_storage do
    on roles(:app) do
      execute :ln, "-s", "#{shared_path}/public/system", "#{current_path}/public/system"
    end
  end

  after :publishing, :symlink_storage, :restart
end
# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

# Default deploy_to directory is /var/www/my_app
# set :deploy_to, '/var/www/my_app'

# Default value for :scm is :git


# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end
