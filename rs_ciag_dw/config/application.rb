require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module RsCiagDw
  class Application < Rails::Application

    config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = 'pt-BR'
    config.time_zone = 'Brasilia'

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true
    config.assets.precompile << /\.(?:svg|eot|woff|ttf)$/
    config.assets.precompile += %w( *.css *.js *.woff *.eot *.svg *.ttf)

    config.assets.precompile += %w( scss/*.css scss/skins/*.css  )
  	config.assets.paths << "#{Rails.root}/app/assets/stylesheets/font"
    
  	# DEVISE
    config.to_prepare do
      Devise::SessionsController.layout "signin"
      # Devise::RegistrationsController.layout ""
      Devise::ConfirmationsController.layout "signup"
      Devise::UnlocksController.layout "signup"
      Devise::PasswordsController.layout "signup"
    end
    
  end
end
