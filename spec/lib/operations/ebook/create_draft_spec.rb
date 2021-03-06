require 'spec_helper.rb'
require 'fileutils'
require 'timecop'

describe Ebook::CreateDraft do
  let(:root_path) { Sinatra::Application.settings.root }
  before do
    Timecop.freeze(Time.local(1991, 5, 11, 10, 30, 0))
  end
  let(:book_stamp) { "456_103000_11051991" }
  let(:draft_path) { "#{root_path}/books_drafts/#{book_stamp}" }
  after do
    Timecop.return
    FileUtils.rm_rf("#{root_path}/books_drafts")
    FileUtils.mkdir_p("#{root_path}/books_drafts")
  end
  let(:text) { File.open("#{root_path}/spec/support/book_files/text.html").read }
  let(:toc) { File.open("#{root_path}/spec/support/book_files/toc.html").read }
  let(:book_opf) { File.open("#{root_path}/spec/support/book_files/book.opf").read }
  let(:image_urls) do
    [
      "http://jakoszczedzacpieniadze.pl/wp-content/uploads/2017/05/FB-Jak-tworzyc-zarabiajace-produkty.png",
      "https://images-na.ssl-images-amazon.com/images/G/01/img15/pet-products/small-tiles/23695_pets_vertical_store_dogs_small_tile_8._CB312176604_.jpg",
    ]
  end
  subject do 
    described_class.new(
      text: text, 
      toc: toc, 
      book_opf: book_opf, 
      draft_path: draft_path,
      image_urls: image_urls,
      )
  end

  it "should create a new dir in books_drafts" do
    subject.call
    expect(Dir.exists?("#{root_path}/books_drafts/#{book_stamp}")).to be_truthy
  end

  it "creates book files in book dir" do
    subject.call
    expect(File.exists?("#{root_path}/books_drafts/#{book_stamp}/text.html")).to be_truthy
    expect(File.exists?("#{root_path}/books_drafts/#{book_stamp}/toc.html")).to be_truthy
    expect(File.exists?("#{root_path}/books_drafts/#{book_stamp}/book.opf")).to be_truthy
  end

  it "creates a directory for images" do
    subject.call
    expect(Dir.exists?("#{root_path}/books_drafts/#{book_stamp}/images")).to be_truthy
  end

  it "copies images" do
    subject.call
    expect(File.exists?("#{root_path}/books_drafts/#{book_stamp}/images/FB-Jak-tworzyc-zarabiajace-produkty.png")).to be_truthy
    expect(File.exists?("#{root_path}/books_drafts/#{book_stamp}/images/23695_pets_vertical_store_dogs_small_tile_8._CB312176604_.jpg")).to be_truthy
  end

  it "it returns path to main source file of the created draft" do
    expect(subject.call).to eq("#{root_path}/books_drafts/#{book_stamp}/book.opf")
  end

  context "one image url is invalid" do
    subject do 
      described_class.new(
        text: text, 
        toc: toc, 
        book_opf: book_opf, 
        draft_path: draft_path,
        image_urls: image_urls.push("http://www.invalidurl.com/image.jpg"),
        )
    end
    it "does not raise exception, it just downloads those which are valid" do
      subject.call
      expect(File.exists?("#{root_path}/books_drafts/#{book_stamp}/images/FB-Jak-tworzyc-zarabiajace-produkty.png")).to be_truthy
      expect(File.exists?("#{root_path}/books_drafts/#{book_stamp}/images/23695_pets_vertical_store_dogs_small_tile_8._CB312176604_.jpg")).to be_truthy
    end
  end
end