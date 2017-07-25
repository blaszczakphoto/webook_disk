require 'spec_helper.rb'
require 'fileutils'
require 'timecop'

describe Ebook::Generate do
  let(:draft_path) { "#{root_path}/books_drafts/#{book_stamp}" }
  let(:book_id) { "3_345" }
  let(:book_stamp) { "123" }

  let(:root_path) { Sinatra::Application.settings.root }
  before do
    Timecop.freeze(Time.local(1991, 5, 11, 10, 30, 0))
    FileUtils.copy_entry("#{root_path}/spec/support/book_draft", "#{root_path}/books_drafts/#{book_stamp}")
    allow_any_instance_of(CalibreLogger).to receive(:log)
  end
  after do
    Timecop.return
    FileUtils.rm_rf("#{root_path}/books_drafts")
    FileUtils.mkdir_p("#{root_path}/books_drafts")
  end
  subject { described_class.new(draft_path: draft_path, book_id: book_id) }

  it "creates a mobi file inside of book_draft directory" do
    subject.call
    expect(File.exists?("#{draft_path}/#{book_id}.mobi")).to eq(true)
  end

  it "calls calibre_logger #log method" do
    expect_any_instance_of(CalibreLogger).to receive(:log)
    subject.call
  end
end