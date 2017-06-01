require 'spec_helper.rb'
require 'fileutils'
require 'timecop'

describe Ebook::CreateDraft do
  let(:root) { Sinatra::Application.settings.root }
  before do
    Timecop.freeze(Time.local(1991, 5, 11, 10, 30, 0))
  end
  let(:expected_book_stamp) { "456_103000_11051991" }
  after do
    Timecop.return
    FileUtils.rm_rf("#{root}/books_drafts")
    FileUtils.mkdir_p("#{root}/books_drafts")
  end
  let(:text) { File.open("#{root}/spec/support/book_files/text.html").read }
  let(:toc) { File.open("#{root}/spec/support/book_files/toc.html").read }
  let(:book_opf) { File.open("#{root}/spec/support/book_files/book.opf").read }
  subject { described_class.new(book_id: 456, text: text, toc: toc, book_opf: book_opf) }

  it "should create a new dir in books_drafts", focus: true do
    subject.call
    expect(Dir.exists?("#{root}/books_drafts/#{expected_book_stamp}")).to be_truthy
  end

  it "creates book files in book dir" do
    subject.call
    expect(File.exists?("#{root}/books_drafts/#{expected_book_stamp}/text.html")).to be_truthy
  end
end