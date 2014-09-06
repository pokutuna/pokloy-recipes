# # required
# - release_path: capistrano provided
# - role: :cron

# # required `set` configurations
# - :application
#   - application name for cron filename on server
# - :cron_server_confd
#   - server config directry (e.g. /etc/cron.d/)
# - :cron_conf_path
#   - config filepath from application root (e.g. config/service.cron.conf)

namespace :cron do

  task :update do
    SSHKit.config.output_verbosity = Logger::DEBUG
    on roles(:cron) do
      execute :sudo, "cp -v #{release_path.join(fetch(:cron_conf_path))} #{File.join(fetch(:cron_server_confd), fetch(:application))}"
      execute :sudo, "chown -R root:root #{fetch(:cron_server_confd)}"
      execute :sudo, "chmod -R 0644 #{fetch(:cron_server_confd)}"
      execute :sudo, "chmod 0755 #{fetch(:cron_server_confd)}"
      execute :sudo, 'service cron reload'
    end
  end

  task :generate_config do
    require 'erb'
    require_relative 'utils'
    set :filepath, ask('cron.conf save to', fetch(:cron_conf_path))
    File.open(fetch(:filepath), 'w'){|f|
      f.print ERB.new(template('cron.conf.erb'), nil, '-').result(binding)
    }
  end

end
