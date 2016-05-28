require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Triptri
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true

    # DEVISE
    config.to_prepare do
      Devise::SessionsController.layout "application"
      # Devise::RegistrationsController.layout ""
      Devise::ConfirmationsController.layout "application"
      Devise::UnlocksController.layout "application"
      Devise::PasswordsController.layout "application"
      Devise::Mailer.layout 'mailer'
    end
    
    # SMTP
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = {
      :address              => 'smtp.gmail.com',
      :port                 => 587,
      :domain               => 'gmail.com',
      :user_name            => 'naorespondatriptri@gmail.com',
      :password             => "Santiago2015!",
      :authentication       => 'plain',
      :enable_starttls_auto => true
    }

    # I18N
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = 'pt-BR'
    config.time_zone = 'Brasilia'

    require 'the_id'

    #config.register_javascript 'autocomplete-rails.js'
    
  end
end
