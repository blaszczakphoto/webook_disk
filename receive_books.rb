require 'sinatra'
require 'kindlegen'
require 'fileutils'
require 'pry'

def generate_ebook
  stdout, stderr, status = Kindlegen.run("books_drafts/1234/book.opf", "-o", "1234.mobi")
  if status == 0
    puts stdout
  else
    $stderr.puts stderr
  end
end

get '/' do
  if settings.development?
    "development!"
  else
    "not development!"
  end
end

post '/' do
  book_id = params['ebook_draft']['book_id']
  draft_path = "books_drafts/#{book_id}"
  FileUtils::mkdir_p draft_path
  File.open("#{draft_path}/text.html", "w") {|f| f.write(params['ebook_draft']['text']) }
  File.open("#{draft_path}/toc.html", "w") {|f| f.write(params['ebook_draft']['toc']) }
  File.open("#{draft_path}/book.opf", "w") {|f| f.write(params['ebook_draft']['book_opf']) }
  generate_ebook
end