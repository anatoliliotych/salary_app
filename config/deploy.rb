set :application, 'salary_app'
set :repo_url, 'git@github.com:anatoliliotych/salary_app.git'

set :deploy_to, '/var/www/salary_app'
set :scm, :git
ask :branch, "master"

set :linked_files, %w{ config/config.yml }
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

set :rbenv_type, :user # or :system, depends on your rbenv setup
set :rbenv_ruby, '2.1.0'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles, :all # default value
set :keep_releases, 10
set :admin_runner, 'deploy'
set :rails_env, "production"

namespace :deploy do
  desc 'Restart application'
  task :restart do
    invoke 'deploy:unicorn:restart'
  end

  after :finishing, 'deploy:cleanup'

  namespace :unicorn do
    pid_path = "#{release_path}/tmp/pids"
    unicorn_pid = "#{pid_path}/unicorn.pid"

    def run_unicorn
      execute "cd #{current_path} ; bundle exec unicorn -E #{fetch(:rails_env)} -c #{current_path}/config/unicorn.rb"
    end

    desc 'Start unicorn'
    task :start do
      on roles(:app) do
        run_unicorn
      end
    end

    desc 'Stop unicorn'
    task :stop do
      on roles(:app) do
        if test "[ -f #{unicorn_pid} ]"
          execute :kill, "-QUIT `cat #{unicorn_pid}`"
        end
      end
    end

    desc 'Force stop unicorn (kill -9)'
    task :force_stop do
      on roles(:app) do
        if test "[ -f #{unicorn_pid} ]"
          execute :kill, "-9 `cat #{unicorn_pid}`"
          execute :rm, unicorn_pid
        end
      end
    end

    desc 'Restart unicorn'
    task :restart do
      on roles(:app) do
        if test "[ -f #{unicorn_pid} ]"
          execute :kill, "-USR2 `cat #{unicorn_pid}`"
        else
          run_unicorn
        end
      end
    end
  end
end

