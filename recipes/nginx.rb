# # required
# - release_path: capistrano provided
# - role: :proxy

# # required `set` configurations
# - :nginx_server_confd
#    - server config directry (e.g. /etc/nginx/sites-enabled/)
# - :nginx_conf_path
#   - config filepath from application root (e.g. config/service.nginx.conf)

namespace :nginx do

  task :setup do
    on roles(:proxy) do
      invoke 'nginx:symlink'
      invoke 'nginx:configtest'
    end
  end

  task :symlink do
    on roles(:proxy) do
      execute :sudo, "ln -fs #{release_path.join(fetch(:nginx_conf_path))} #{fetch(:nginx_server_confd)}"
    end
  end

  task :reload do
    on roles(:proxy) do
      execute :sudo, 'service nginx reload'
    end
  end

  task :restart do
    set :confirm, ask('restart? [Y/n]', nil)
    if fetch(:confirm).match(/^Y/)
      on roles(:proxy) do
        execute :sudo, 'service nginx restart'
      end
    end
  end

  task :configtest do
      on roles(:proxy) do
        execute :sudo, 'service nginx configtest'
      end
  end

  after :symlink, :reload
end
