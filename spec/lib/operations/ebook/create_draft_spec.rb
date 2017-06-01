require 'spec_helper.rb'
require 'fileutils'
require 'timecop'

describe Ebook::CreateDraft do
  before do
    Timecop.freeze(Time.local(1991, 5, 11, 10, 30, 0))
  end
  after do
    Timecop.return
    FileUtils.rm_rf("#{Dir.pwd}/books_drafts")
    FileUtils.mkdir_p("#{Dir.pwd}/books_drafts")
  end

  it "should create a new dir in books_drafts", focus: true do
    described_class.new(book_id: 456).call
    expect(Dir.exists?("#{Dir.pwd}/books_drafts/456_103000_11051991")).to be_truthy
  end

  xit "creates book files in book dir" do
    
  end
end