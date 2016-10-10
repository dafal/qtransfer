require 'dragonfly'

# Configure
Dragonfly.app.configure do
  plugin :imagemagick

  secret "my_super_secret_dragonly_key"

  url_format "/media/:job/:name"

  datastore :file,
    root_path: Rails.root.join('data', Rails.env),
    server_root: Rails.root.join('public')
end

# Logger
Dragonfly.logger = Rails.logger

# Mount as middleware
Rails.application.middleware.use Dragonfly::Middleware

# Add model functionality
if defined?(ActiveRecord::Base)
  ActiveRecord::Base.extend Dragonfly::Model
  ActiveRecord::Base.extend Dragonfly::Model::Validations
end
