require_relative '../../../receive_books.rb'

module Ebook
  class Generate
    attr_accessor :draft_path, :book_id, :calibre_logger

    CALIBRE_SHELL_COMMAND = 'ebook-convert'

    def initialize(draft_path:, book_id:, calibre_logger: CalibreLogger.new)
      @draft_path = draft_path
      @book_id = book_id
      @calibre_logger = calibre_logger
    end

    def call
      generate_mobi_file
    end

    private

    def generate_mobi_file
      calibre_command_output = run_calibre_shell_command
      calibre_logger_log(calibre_command_output)
    end

    def run_calibre_shell_command
      `#{CALIBRE_SHELL_COMMAND} #{draft_file_path} #{output_file_path}`
    end

    def draft_file_path
      "#{draft_path}/book.opf"
    end

    def output_file_path
      "#{draft_path}/#{book_id}.mobi"
    end

    def calibre_logger_log(text)
      calibre_logger.log(text)
    end
  end
end