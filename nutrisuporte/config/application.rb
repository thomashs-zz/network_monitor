require File.expand_path('../boot', __FILE__)

require 'rails/all'

if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line
  Bundler.require(*Rails.groups(:assets => %w(development test)))
  # If you want your assets lazily compiled in production, use this line
  # Bundler.require(:default, :assets, Rails.env)
end

module Nutrisuporte
  class Application < Rails::Application
    config.time_zone = 'Brasilia'
    config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = 'pt-BR'
    config.encoding = "utf-8"
    config.filter_parameters += [:password]
    config.active_support.escape_html_entities_in_json = true
    config.active_record.whitelist_attributes = true
    config.assets.enabled = true
    config.assets.version = '1.0'
    config.assets.paths << "#{Rails.root}/app/assets/fonts"
    
    # SMTP
    config.action_mailer.smtp_settings = {
      address:              'smtp.gmail.com',
      port:                 587,
      domain:               'nutrisuporte.com.br',
      user_name:            'nutrisuporte@nutrisuporte.com.br',
      password:             'assistencia1079',
      authentication:       'login',
      enable_starttls_auto: true,
      openssl_verify_mode:  'none'
    }
    
  end
end
