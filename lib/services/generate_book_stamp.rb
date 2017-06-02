class GenerateBookStamp
  attr_accessor :book_id
  def initialize(book_id)
    @book_id = book_id
  end

  def call
    book_stamp
  end

  private

  def book_stamp
    "#{book_id.to_s}_#{time_stamp}"
  end

  def time_stamp
    Time.now.strftime("%H%M%S_%d%m%Y")
  end

end