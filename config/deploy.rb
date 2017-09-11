lock "3.8.1"

set :application, "webook_disk"
set :repo_url, "git@github.com:blaszczakphoto/webook_disk.git"
set :branch, 'master'
append :linked_dirs, "log"
set :keep_releases, 1
set :default_shell, "/bin/bash --login"
set :ssh_options, { :forward_agent => true }
set :deploy_to, "/home/profiart/domains/webookdisk.profiart.pl/public_html"
set :tmp_dir, '/home/profiart/tmp'

after 'deploy:log_revision', 'deploy:restart_sinatra_server'