# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

ENV['CLAMD_TCP_HOST'] = Rails.configuration.x.app_config['clamd_tcp_host']
ENV['CLAMD_TCP_PORT'] = Rails.configuration.x.app_config['clamd_tcp_port']
