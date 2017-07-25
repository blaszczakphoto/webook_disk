require_relative '../../../receive_books.rb'
require "open-uri"
require 'uri'

module Ebook
  class CreateDraft
    attr_accessor :book_stamp, :text, :toc, :book_opf, :draft_path, :image_urls

    def initialize(book_stamp:, text:, toc:, book_opf:, draft_path:, image_urls:)
      @book_stamp = book_stamp
      @text = text
      @toc = toc
      @book_opf = book_opf
      @draft_path = draft_path
      @image_urls = image_urls
    end

    def call
      create_book_draft_dir
      create_images_dir
      copy_images
      main_draft_source_filepath = create_book_draft_files
      main_draft_source_filepath
    end

    private

    def create_book_draft_files
      save_file_from_string("text.html", text)
      save_file_from_string("toc.html", toc)
      save_file_from_string("book.opf", book_opf)
    end

    def create_book_draft_dir
      FileUtils::mkdir_p draft_path
    end

    def save_file_from_string(file_name, string)
      file_path = "#{draft_path}/#{file_name}"
      File.open(file_path, "w") {|f| f.write(string) }
      file_path
    end

    def create_images_dir
      FileUtils::mkdir_p "#{draft_path}/images"
    end

    def copy_images
      image_urls.each do |url|
        uri = URI.parse(url)
        File.open("#{draft_path}/images/#{File.basename(uri.path)}", 'wb') do |fo|
          begin
            fo.write open(url).read 
          rescue OpenURI::HTTPError
            next
          end
        end
      end
    end
  end
end