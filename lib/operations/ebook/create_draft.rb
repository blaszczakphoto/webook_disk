require_relative '../../../receive_books.rb'

module Ebook
  class CreateDraft
    attr_accessor :book_id
    def initialize(book_id:)
      @book_id = book_id
    end

    def call
      book_stamp = book_id.to_s + '_' +  Time.now.strftime("%H%M%S_%d%m%Y")
      draft_path = "#{Sinatra::Application.settings.root}/books_drafts/#{book_stamp}"
      FileUtils::mkdir_p draft_path
    end
  end
end