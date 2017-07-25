require 'sinatra'
require_relative 'config'
require 'kindlegen'
require 'fileutils'
require 'dropbox_api'
require_relative 'lib/services/generate_book_stamp'
require_relative 'lib/operations/ebook/create_draft'
require_relative 'lib/operations/ebook/upload_to_dropbox'
require_relative 'lib/operations/ebook/generate'

if settings.development? || settings.test?
  require 'pry'
  require 'dotenv/load'
end



get '/' do
  if settings.development?
    "development!"
  else
    "not development test"
  end
end

get '/test' do
  stdout, stderr, status = Kindlegen.run("/home/profiart/domains/webookdisk.profiart.pl/public_html/current/books_drafts/5_125157_22072017/book.opf", "-o", "test.mobi")
  File.open("#{settings.root}/kindlegenlog", "a+") do |f|
    f.write(stdout)
  end
  if status == 0
    puts stdout
  else
    $stderr.puts stderr
  end
  "success"
end

get '/test_cmd' do
 stdout = `ebook-convert /home/profiart/domains/webookdisk.profiart.pl/public_html/current/books_drafts/5_125157_22072017/book.opf /home/profiart/domains/webookdisk.profiart.pl/public_html/current/books_drafts/5_125157_22072017/book2.mobi`
 File.open("#{settings.root}/kindlegenlog", "a+") do |f|
   f.write(stdout)
 end
 "success"
end

post '/' do
  create_draft_files
  generate_ebook(book_stamp, draft_path)
  upload_to_dropbox
end

private

def generate_ebook(book_id, draft_path)
  Ebook::Generate.new(book_id: book_id, draft_path: draft_path).call
end

def create_draft_files
  Ebook::CreateDraft.new(
    book_stamp: book_stamp, 
    text: params['ebook_draft']['text'],
    toc: params['ebook_draft']['toc'],
    book_opf: params['ebook_draft']['book_opf'],
    draft_path: draft_path,
    image_urls: params['ebook_draft']['image_urls']
  ).call
end

def upload_to_dropbox
  Ebook::UploadToDropbox.new(book_stamp, draft_path).call
end

def book_stamp
  @book_stamp ||= GenerateBookStamp.new(params['ebook_draft']['book_id']).call
end

def draft_path
  @draft_path ||= "#{settings.root}/books_drafts/#{book_stamp}"
end