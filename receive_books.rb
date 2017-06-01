require 'sinatra'
require_relative 'config'
require 'kindlegen'
require 'fileutils'
require 'dropbox_api'

if settings.development? || settings.test?
  require 'pry'
  require 'dotenv/load'
end

def generate_ebook(book_id, draft_path)
  stdout, stderr, status = Kindlegen.run("#{draft_path}/book.opf", "-o", "#{book_id}.mobi")
  if status == 0
    puts stdout
  else
    $stderr.puts stderr
  end
end

get '/' do
  puts settings.root
  if settings.development?
    "development!"
  else
    "not development!"
  end
end

post '/' do
  book_id = params['ebook_draft']['book_id'] + '_' +  Time.now.strftime("%H%M%S_%m%Y")
  draft_path = "#{settings.root}/books_drafts/#{book_id}"
  FileUtils::mkdir_p draft_path
  File.open("#{draft_path}/text.html", "w") {|f| f.write(params['ebook_draft']['text']) }
  File.open("#{draft_path}/toc.html", "w") {|f| f.write(params['ebook_draft']['toc']) }
  File.open("#{draft_path}/book.opf", "w") {|f| f.write(params['ebook_draft']['book_opf']) }
  generate_ebook(book_id, draft_path)
  token = ENV.fetch("DROPBOX_TOKEN")
  client = DropboxApi::Client.new(token)
  file = client.upload("/#{book_id}.mobi", IO.read("#{draft_path}/#{book_id}.mobi"))
  link = client.create_shared_link_with_settings("/#{book_id}.mobi", {short_url: false})
  FileUtils.rm_rf(draft_path)
  link.url.gsub("dl=0", "dl=1")
end