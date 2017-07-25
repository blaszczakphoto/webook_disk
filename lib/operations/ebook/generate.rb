require_relative '../../../receive_books.rb'
require_relative '../../calibre_logger'

module Ebook
  class Generate
    attr_accessor :draft_path, :book_name, :calibre_logger, :draft_source_file_path

    def initialize(draft_path:, book_name:, calibre_logger: CalibreLogger.new, draft_source_file_path:)
      @draft_path = draft_path
      @book_name = book_name
      @calibre_logger = calibre_logger
      @draft_source_file_path = draft_source_file_path
    end

    def call
      generate_mobi_file
      output_file_path
    end

    private

    def generate_mobi_file
      calibre_command_output = run_calibre_shell_command
      log_calibre_output(calibre_command_output)
    end

    def run_calibre_shell_command
      calibre_shell_command = "ebook-convert"
      `#{calibre_shell_command} #{draft_source_file_path} #{output_file_path}`
    end

    def output_file_path
      "#{draft_path}/#{book_name}.mobi"
    end

    def log_calibre_output(text)
      calibre_logger.log(text)
    end
  end
end