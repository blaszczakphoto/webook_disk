require 'spec_helper.rb'
require 'fileutils'

describe DraftCleaner do
  let(:book_draft_source) { "#{Sinatra::Application.settings.root}/spec/support/book_draft" }
  let(:draft_path) { "#{Sinatra::Application.settings.root}/books_drafts/12345" }
  before { FileUtils.copy_entry(book_draft_source, draft_path) }
  subject { described_class.new(draft_path: draft_path) }

  it "removes draft path directory" do
    subject.call
    expect(File.exists?(draft_path)).to be_falsey
  end
end