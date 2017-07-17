require_relative '../../../receive_books.rb'

module Ebook
  class UploadToDropbox
    attr_accessor :book_stamp, :draft_path

    def initialize(book_stamp, draft_path)
      @book_stamp = book_stamp
      @draft_path = draft_path
    end
    
    def call
      upload!
      link = create_shareable_link
      clean_directories!
      direct_download_link(link)
    end

    private

    def token
      @token ||= ENV.fetch("DROPBOX_TOKEN")
    end

    def client
      @client ||= DropboxApi::Client.new(token)
    end

    def create_shareable_link
      client.create_shared_link_with_settings("/#{book_stamp}.mobi", {short_url: false})
    end

    def direct_download_link(link)
      link.url.gsub("dl=0", "dl=1")
    end

    def upload!
      client.upload("/#{book_stamp}.mobi", IO.read("#{draft_path}/#{book_stamp}.mobi"))
    end

    def clean_directories!
      # FileUtils.rm_rf(draft_path)
    end
  end
end