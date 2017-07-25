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

post '/' do
  main_draft_source_filepath = create_draft_files
  mobi_file_path = generate_ebook(book_stamp, draft_path, main_draft_source_filepath)
  link_to_download = upload_to_dropbox(mobi_file_path)
  link_to_download
end

private

def generate_ebook(book_name, draft_path, main_draft_source_filepath)
  Ebook::Generate.new(book_name: book_name, 
    draft_path: draft_path, 
    draft_source_file_path: main_draft_source_filepath
    ).call
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

def upload_to_dropbox(mobi_file_path)
  Ebook::UploadToDropbox.new(book_name: book_stamp, draft_path: draft_path, mobi_file_path: mobi_file_path).call
end

def book_stamp
  @book_stamp ||= GenerateBookStamp.new(params['ebook_draft']['book_id']).call
end

def draft_path
  @draft_path ||= "#{settings.root}/books_drafts/#{book_stamp}"
end