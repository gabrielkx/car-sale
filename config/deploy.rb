# config valid for current version and patch releases of Capistrano
lock "~> 3.10"

set :application, "car-sale"
set :repo_url, "git@github.com:gabrielkx/car-sale.git"
set :branch, 'main'

set :user, 'deploy'
set :rvm_type, :user
set :rvm_ruby_version, '3.1.2'

on roles(:app) do
  execute "source /home/deploy/.rvm/scripts/rvm"
  execute "rvm use 3.1.2"
end

set :deploy_to, "/var/www/car-sale"

append :linked_files, "config/database.yml","config/storage.yml", 'config/secrets.yml', 'config/credentials.yml.enc', 'config/master.key'
append :linked_dirs, "log", "tmp"

set :keep_releases, 5
set :migration_role, :app


set :puma_pid, "#{shared_path}/tmp/pids/puma.pid"
set :puma_bind, "unix://#{shared_path}/tmp/sockets/puma.sock"
set :puma_access_log, "#{shared_path}/log/puma_access.log"
set :puma_error_log, "#{shared_path}/log/puma_error.log"

set :nginx_sites_available_path, "/etc/nginx/sites-available"
set :nginx_sites_enabled_path, "/etc/nginx/sites-enabled"


append :linked_files, "config/database.yml","config/storage.yml", 'config/secrets.yml', 'config/credentials.yml.enc', 'config/master.key'
append :linked_dirs, "log", "tmp"

set :keep_releases, 5
set :migration_role, :app


set :puma_pid, "#{shared_path}/tmp/pids/puma.pid"
set :puma_bind, "unix://#{shared_path}/tmp/sockets/puma.sock"
set :puma_access_log, "#{shared_path}/log/puma_access.log"
set :puma_error_log, "#{shared_path}/log/puma_error.log"

set :nginx_sites_available_path, "/etc/nginx/sites-available"
set :nginx_sites_enabled_path, "/etc/nginx/sites-enabled"


namespace :puma do
  desc 'Create Puma dirs'
  task :create_dirs do
    on roles(:app) do
      execute "mkdir #{shared_path}/tmp/sockets -p"
      execute "mkdir #{shared_path}/tmp/pids -p"
    end
  end

  desc "Restart Nginx"
  task :nginx_restart do
    on roles(:app) do
      execute "sudo service nginx restart"
    end
  end

  desc 'Start puma'
  task :start do
    on roles(:app) do
      if test "[ -f #{fetch(:puma_pid)} ]" and test :kill, "-0 $( cat #{fetch(:puma_pid)} )"
        info 'Puma is already running'
      else
        within current_path do
          with rack_env: fetch(:puma_env) do
            execute :puma, "-C #{fetch(:puma_conf)}"
          end
        end
      end
    end
  end

  desc 'Restart'
  task :restart do
    on roles(:app) do
      execute :kill, "-9 $( cat #{fetch(:puma_pid)} )"
      within current_path do
        with rack_env: fetch(:puma_env) do
          execute :puma, "-C #{fetch(:puma_conf)}"
        end
      end
    end
  end

  desc 'stop'
  task :stop do
    on roles(:app) do
      execute :kill, "-9 $( cat #{fetch(:puma_pid)} )"
    end
  end

  before :start, :create_dirs
  after :start, :nginx_restart
end
