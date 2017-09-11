# Prerequisites
- ruby 2.4.1
- gem bundler installed
- calibre program installed - https://calibre-ebook.com/download

# Setup
1. `git clone https://github.com/blaszczakphoto/webook_disk.git`
2. `bundle install`
3. `cp .env.sample .env`
4. Paste your dropbox token or contact me to obtain mine dropbox token in file .env
5. Run server:
`ruby receive_books.rb`


# How to deploy
you must have access to SSH, because capistrano works via it
`cap production deploy`

# Intall on server
- add to bash dropbox token

# Tests
`rspec`  

# Run locally
`bundle exec rackup -p 4567 -E development`

# Resources
- http://jesus.github.io/dropbox_api/
