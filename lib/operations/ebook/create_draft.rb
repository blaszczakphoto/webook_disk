require_relative '../../../receive_books.rb'

module Ebook
  class CreateDraft
    attr_accessor :book_stamp, :text, :toc, :book_opf, :draft_path

    def initialize(book_stamp:, text:, toc:, book_opf:, draft_path:)
      @book_stamp = book_stamp
      @text = text
      @toc = toc
      @book_opf = book_opf
      @draft_path = draft_path
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
  end
end