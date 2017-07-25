require_relative '../../../receive_books.rb'

module Ebook
  class UploadToDropbox
    attr_accessor :book_name, :draft_path, :mobi_file_path

    def initialize(book_name:, draft_path:, mobi_file_path:)
      @book_name = book_name
      @draft_path = draft_path
      @mobi_file_path = mobi_file_path
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
      client.create_shared_link_with_settings("/#{book_name}.mobi", {short_url: false})
    end

    def direct_download_link(link)
      link.url.gsub("dl=0", "dl=1")
    end

    def upload!
      client.upload("/#{book_name}.mobi", mobi_file_binary_content)
    end

    def mobi_file_binary_content
      IO.read(mobi_file_path)
    end

    def clean_directories!
      FileUtils.rm_rf(draft_path)
    end
  end
end