require 'spec_helper.rb'
require 'fileutils'
require 'timecop'

describe CalibreLogger do
  let(:kindle_log_path) { "#{Sinatra::Application.settings.root}/spec/support/kindle.log" }
  before do
    File.open(kindle_log_path, "w") do |f|
    end
  end
  after do
    FileUtils.rm_f(kindle_log_path)
  end
  subject { CalibreLogger.new(log_file: kindle_log_path) }

  it "appends text to the end of logfile" do
    subject.log("log some text")
    expect(File.open(kindle_log_path).read).to eq("log some text")
  end
end