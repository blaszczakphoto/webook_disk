require 'spec_helper.rb'
require 'fileutils'

describe CalibreLogger do
  let(:kindle_log_path) { "#{Sinatra::Application.settings.root}/spec/support/kindle.log" }
  before { File.open(kindle_log_path, "w") {} }
  after { FileUtils.rm_f(kindle_log_path) }

  subject { CalibreLogger.new(log_file: kindle_log_path) }

  it "appends text to the end of logfile" do
    subject.log("log some text")
    log_file_content = File.open(kindle_log_path).read
    expect(log_file_content).to eq("log some text")
  end
end