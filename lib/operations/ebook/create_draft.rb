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
      create_book_draft_files
      create_images_dir
      copy_images
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
      File.open("#{draft_path}/#{file_name}", "w") {|f| f.write(string) }
    end

    def create_images_dir
      FileUtils::mkdir_p "#{draft_path}/images"
    end

    def copy_images
      image_urls.each do |url|
        uri = URI.parse(url)
        File.open("#{draft_path}/images/#{File.basename(uri.path)}", 'wb') do |fo|
          fo.write open(url).read 
        end
      end
    end
  end
end