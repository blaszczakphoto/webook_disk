require_relative '../../../receive_books.rb'
require "open-uri"
require 'uri'

module Ebook
  class Generate
    attr_accessor :draft_path, :book_id

    def initialize(draft_path:, book_id:)
      @draft_path = draft_path
      @book_id = book_id
    end

    def call
    end

    private
  end
end