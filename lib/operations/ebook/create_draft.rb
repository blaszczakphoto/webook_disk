require_relative '../../../receive_books.rb'

module Ebook
  class CreateDraft
    attr_accessor :book_id, :text, :toc, :book_opf

    def initialize(book_id:, text:, toc:, book_opf:)
      @book_id = book_id
      @text = text
      @toc = toc
      @book_opf = book_opf
    end

    def call
      create_book_draft_dir
      create_book_draft_files
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

    def book_stamp
      "#{book_id.to_s}_#{time_stamp}"
    end

    def time_stamp
      Time.now.strftime("%H%M%S_%d%m%Y")
    end

    def draft_path
      @draft_path ||= "#{Sinatra::Application.settings.root}/books_drafts/#{book_stamp}" 
    end
  end
end