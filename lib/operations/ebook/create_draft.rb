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
      book_stamp = book_id.to_s + '_' +  Time.now.strftime("%H%M%S_%d%m%Y")
      draft_path = "#{Sinatra::Application.settings.root}/books_drafts/#{book_stamp}"
      FileUtils::mkdir_p draft_path
      File.open("#{draft_path}/text.html", "w") {|f| f.write(text) }
      File.open("#{draft_path}/toc.html", "w") {|f| f.write(toc) }
      File.open("#{draft_path}/book.opf", "w") {|f| f.write(book_opf) }
    end
  end
end