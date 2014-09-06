# coding: utf-8
# # required
# - release_path: capistrano provided
# - role: :app

# # required `set` configuration
# - :supervisor_program_name
#   - a name referenced from in config like `[program:ApplicationName]`
# - :supervisor_server_confd
#   - server config directory (e.g. /etc/supervisor/conf.d/)
# - :supervisor_conf_path
#   - config filepath from application root (e.g. config/service.supervisord.conf)
#
# - :supervisor_user (only for config generation)
#   - username

namespace :supervisor do

  task :restart_app do
    on roles(:app) do
      execute :sudo, "supervisorctl restart #{fetch(:supervisor_program_name)}"
    end
  end

  task :symlink do
    on roles(:app) do
      execute :sudo, "ln -fs #{release_path.join(fetch(:supervisor_conf_path))} #{fetch(:supervisor_server_confd)}"
    end
  end

  task :status do
    on roles(:app) do
      puts "#{host}: #{capture(:sudo, "supervisorctl status #{fetch(:supervisor_program_name)}")}"
    end
  end

  task :tail do
    require 'sshkit'
    require 'logger'
    SSHKit.config.output_verbosity = Logger::DEBUG
    on roles(:app) do
      execute :sudo, "supervisorctl tail -f #{fetch(:supervisor_program_name)}"
    end
  end

  desc 'supervisord を再起動せず設定を読込直す'
  # eventlistener とかは再読み込みされないっぽい
  task :reread do
    on roles(:app) do
      execute :sudo, 'supervisorctl reread'
    end
  end

  after :symlink, :reread

  task :generate_config do
    require 'erb'
    require_relative 'utils'
    set :filepath, ask('supervisord.conf save to', './config/supervisord.conf')
    File.open(fetch(:filepath), 'w'){|f|
      f.print ERB.new(template('supervisord.conf.erb'), nil, '-').result(binding)
    }
  end

end
