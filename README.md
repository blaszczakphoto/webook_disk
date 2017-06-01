# Setup
bundle
ruby receive_books.rb
fill .env.sample with dropbox token

# How to deploy
- login to SSH
- cd domains/webookdisk.profiart.pl/public_html
- git pull origin master
- bundle install --without development test
- ps aux | kill daemon
- nohup ruby receive_books.rb -p 3012 -e production >> log/production.log 2>&1 &

# Intall on server
- add to bash dropbox token

# Resources
- http://jesus.github.io/dropbox_api/