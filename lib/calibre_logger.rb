class CalibreLogger
  attr_reader :log_file

  DEFAULT_LOG_FILE = "#{Sinatra::Application.settings.calibre_logger_file_log_path}"

  def initialize(log_file: DEFAULT_LOG_FILE)
    @log_file = log_file
  end

  def log(text)
    append_to_log_file(text)
  end

  private

  def append_to_log_file(text)
    File.open(log_file, "a+") do |f|
      f.write(text)
    end
  end
end