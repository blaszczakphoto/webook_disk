class CalibreLogger
  attr_reader :log_file

  def initialize(log_file: "#{Sinatra::Application.settings.root}/kindlegenlog")
    @log_file = log_file
  end

  def log(text)
    File.open(log_file, "a+") do |f|
      f.write(text)
    end
  end
end