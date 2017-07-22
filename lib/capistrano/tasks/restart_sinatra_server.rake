  require 'pry'


namespace :deploy do
  task :stop_server  do
    on roles(:all) do |_host|
      within(fetch(:deploy_to)) do
        server_pid = capture('ps aux | grep "[p]uma 3.9.1 (tcp://0.0.0.0:3012)" | awk \'{print $2}\'')
        if server_pid == ''
          puts 'No server running'
        else
          puts "Found server running... PID: #{server_pid}"
          execute(:kill, server_pid)
        end
      end
    end
  end

  task :start_server do
    on roles(:all) do |_host|
      within(fetch(:deploy_to)) do
        within('current') do
          execute(:bundle, :exec, :rackup ,"-p #{fetch(:web_server_port)} -E production -D")
        end
      end
    end
  end

  
  task :restart_sinatra_server do
    invoke "deploy:stop_server"
    invoke "deploy:start_server"
  end
end