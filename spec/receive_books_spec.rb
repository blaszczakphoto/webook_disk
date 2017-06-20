require 'spec_helper.rb'
require 'fileutils'
describe "Application" do
  it "should allow accessing the home page" do
    get '/'
    expect(last_response).to be_ok
  end

  it "should return url to uploaded mobi file" do
    text = File.open("#{Dir.pwd}/spec/support/book_files/text.html").read
    toc = File.open("#{Dir.pwd}/spec/support/book_files/toc.html").read
    book_opf = File.open("#{Dir.pwd}/spec/support/book_files/book.opf").read
    params = {
      ebook_draft: {
        book_id: 1234,
        text: text,
        toc: toc,
        book_opf: book_opf,
        image_urls: [
          "http://jakoszczedzacpieniadze.pl/wp-content/uploads/2017/05/FB-Jak-tworzyc-zarabiajace-produkty.png",
          "https://images-na.ssl-images-amazon.com/images/G/01/img15/pet-products/small-tiles/23695_pets_vertical_store_dogs_small_tile_8._CB312176604_.jpg",
        ]
      }
    }
    post '/', params
    puts last_response.body
    expect(last_response.body).to include("mobi")
  end
end