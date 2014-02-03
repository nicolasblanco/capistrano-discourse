require 'pry'

set :application, 'discourse'
set :repo_url, 'https://github.com/discourse/discourse.git'

# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

set :branch, "v0.9.8.3"

set :deploy_to, '/home/web/app'
set :scm, :git

# set :format, :pretty
# set :log_level, :debug
# set :pty, true

set :linked_files, %w{config/discourse.conf config/thin.yml config/sidekiq.yml}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system plugins public/uploads}

# set :default_env, { path: "/opt/ruby/bin:$PATH" }
set :keep_releases, 5

set :rbenv_type, :user
set :rbenv_ruby, '2.1.0'

fetch(:default_env).merge!(ruby_gc_malloc_limit: 90000000)
set :rbenv_map_bins, %w{rake gem bundle ruby rails thin}

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      within release_path do
        execute :bundle, :exec, :thin, "-C config/thin.yml restart"
      end
    end
  end

  #after :restart, :clear_cache do
  #  on roles(:web), in: :groups, limit: 3, wait: 10 do
  #    # Here we can do anything such as:
  #    # within release_path do
  #    #   execute :rake, 'cache:clear'
  #    # end
  #  end
  #end

  #before :compile_assets, :source_profile do
  #  on roles(:web) do
  #    execute :source, "~/.profile"
  #  end
  #end

  after :finishing, 'deploy:cleanup'

end
