require 'sinatra'
require_relative 'config'
require 'kindlegen'
require 'fileutils'
require 'dropbox_api'
require 'sentry-raven'
require_relative 'lib/services/generate_book_stamp'
require_relative 'lib/operations/ebook/create_draft'
require_relative 'lib/operations/ebook/upload_to_dropbox'
require_relative 'lib/operations/ebook/generate'
require_relative 'lib/draft_cleaner'

if settings.development? || settings.test?
  require 'pry'
  require 'dotenv/load'
end

get '/test_raven' do
  Raven.capture do
    # capture any exceptions which happen during execution of this block
    1 / 0
  end
end

get '/' do
  if settings.development?
    "development!"
  else
    "not development -> production"
  end
end

get '/test-settings' do
  settings.calibre_logger_file_log_path
end

post '/' do
  Raven.capture do
    main_draft_source_file_path = create_draft_files
    mobi_file_path = generate_ebook(book_stamp, draft_path, main_draft_source_file_path)
    link_to_download = upload_to_dropbox(mobi_file_path)
    clean_draft_directory!
    link_to_download
  end
end

private

def generate_ebook(book_name, draft_path, main_draft_source_file_path)
  Ebook::Generate.new(book_name: book_name, 
    draft_path: draft_path, 
    draft_source_file_path: main_draft_source_file_path
    ).call
end

def create_draft_files
  Ebook::CreateDraft.new(
    text: params['ebook_draft']['text'],
    toc: params['ebook_draft']['toc'],
    book_opf: params['ebook_draft']['book_opf'],
    draft_path: draft_path,
    image_urls: params['ebook_draft']['image_urls']
  ).call
end

def upload_to_dropbox(mobi_file_path)
  Ebook::UploadToDropbox.new(book_name: book_stamp, 
    draft_path: draft_path, 
    mobi_file_path: mobi_file_path
    ).call
end

def clean_draft_directory!
  DraftCleaner.new(draft_path: draft_path).call
end

def book_stamp
  @book_stamp ||= GenerateBookStamp.new(params['ebook_draft']['book_id']).call
end

def draft_path
  @draft_path ||= "#{settings.root}/books_drafts/#{book_stamp}"
end