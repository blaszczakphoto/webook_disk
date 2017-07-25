require_relative '../receive_books.rb'

class DraftCleaner
  attr_accessor :draft_path

  def initialize(draft_path:)
    @draft_path = draft_path
  end
  
  def call
    clean_directories!
  end

  private

  def clean_directories!
    FileUtils.rm_rf(draft_path)
  end
end
