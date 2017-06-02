require 'spec_helper.rb'
require 'fileutils'
require 'timecop'

describe GenerateBookStamp do
  let(:book_id) { 456 }
  subject { described_class.new(book_id) }
  it "generates valid book stamp" do
    Timecop.freeze(Time.local(1991, 5, 11, 10, 30, 0))
    expected_book_stamp = "456_103000_11051991"
    expect(subject.call).to eq(expected_book_stamp)
    Timecop.return
  end
end