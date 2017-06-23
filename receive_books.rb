require 'sinatra'
require_relative 'config'
require 'kindlegen'
require 'fileutils'
require 'dropbox_api'
require_relative 'lib/services/generate_book_stamp'
require_relative 'lib/operations/ebook/create_draft'
require_relative 'lib/operations/ebook/upload_to_dropbox'

if settings.development? || settings.test?
  require 'pry'
  require 'dotenv/load'
end



get '/' do
  if settings.development?
    "development!"
  else
    "not development!!!!"
  end
end

post '/' do
  create_draft_files
  generate_ebook(book_stamp, draft_path)
  upload_to_dropbox
end

private

def generate_ebook(book_id, draft_path)
  stdout, stderr, status = Kindlegen.run("#{draft_path}/book.opf", "-o", "#{book_id}.mobi")
  if status == 0
    puts stdout
  else
    $stderr.puts stderr
  end
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