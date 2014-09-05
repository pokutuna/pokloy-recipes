# # required
# - release_path: capistrano provided
# - :proxy role :

# # required `set` configrations
# - :nginx_confd: server config directry (e.g. /etc/nginx/sites-enabled/)
# - :nginx_conf_path: config filepath from application root (e.g. config/service.nginx.conf)

namespace :nginx do

  task :symlink do
    on roles(:proxy) do
      execute :sudo, "ln -fs #{release_path.join(fetch(:nginx_conf_path))} #{fetch(:nginx_confd)}"
    end
  end

  task :reload do
    on roles(:proxy) do
      execute :sudo, 'service nginx reload'
    end
  end

  task :restart do
    ask :confirm, 'restart? [Y/n]'
    if fetch(:confirm).match(/^Y/)
      on roles(:proxy) do
        execute :sudo, 'service nginx restart'
      end
    end
  end

  task :configtest do
      on roles(:proxy) do
        execute :sudo, 'service nginx restart'
      end
  end

  after :symlink, :reload
end
