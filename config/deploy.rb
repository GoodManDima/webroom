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
