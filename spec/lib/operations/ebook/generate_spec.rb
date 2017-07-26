require 'spec_helper.rb'
require 'fileutils'
require 'timecop'

describe Ebook::Generate do
  let(:root_path) { Sinatra::Application.settings.root }
  let(:draft_path) { "#{root_path}/books_drafts/123" }
  let(:book_name) { "3_345" }
  let(:draft_source_file_path) { "#{draft_path}/book.opf" }

  before do
    FileUtils.copy_entry("#{root_path}/spec/support/book_draft", "#{draft_path}")
    allow_any_instance_of(CalibreLogger).to receive(:log)
  end
  after do
    FileUtils.rm_rf("#{draft_path}")
    FileUtils.mkdir_p("#{draft_path}")
  end
  subject do
    described_class.new(draft_path: draft_path, 
                        book_name: book_name, 
                        draft_source_file_path: draft_source_file_path)
  end

  it "creates a mobi file inside of book_draft directory" do
    subject.call
    expect(File.exists?("#{draft_path}/#{book_name}.mobi")).to eq(true)
  end

  it "calls calibre_logger #log method" do
    expect_any_instance_of(CalibreLogger).to receive(:log)
    subject.call
  end
end