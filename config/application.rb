require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module PhApp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    config.autoload_paths += %W(#{config.root}/app/models/niches)
    config.autoload_paths += %W(#{config.root}/app/models/categories)
    config.autoload_paths += %W(#{config.root}/app/models/media_urls)
    config.exceptions_app = self.routes
    config.time_zone = 'Abu Dhabi'
    config.active_job.queue_adapter = :sidekiq

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
