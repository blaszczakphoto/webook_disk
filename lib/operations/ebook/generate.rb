require_relative '../../../receive_books.rb'

module Ebook
  class Generate
    attr_accessor :draft_path, :book_id

    def initialize(draft_path:, book_id:)
      @draft_path = draft_path
      @book_id = book_id
    end

    def call
      draft_file_path = "#{draft_path}/book.opf"
      output_file_path = "#{draft_path}/#{book_id}.mobi"

      stdout = `ebook-convert #{draft_file_path} #{output_file_path}`

      File.open("#{Sinatra::Application.settings.root}/kindlegenlog", "a+") do |f|
        f.write(stdout)
      end
    end

    private
  end
end