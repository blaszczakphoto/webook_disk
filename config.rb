set :foo, 'bar'
set :root, File.dirname(__FILE__)
set :calibre_logger_file_log_path, "#{settings.root}/log/calibre.log"
require "sentry-raven"

Raven.configure do |config|
  config.dsn = 'https://b7a4bbaf714e4041b59787860a339add:a366c707be2b4a609b7e71dbb0418066@sentry.io/215212'
  config.excluded_exceptions = []
  # config.environments = %w(production)
end