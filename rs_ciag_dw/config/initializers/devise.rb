Devise.setup do |config|
  config.secret_key = 'e3d466abb3bc82ca2c8e8d8dd8a18c3fbd1a1e3f085250798e0f2757dac95c32ca1d4d2069dd7eba58fa75b90ac16cb7285783496fac3da11aa2421c3d280aec'
  config.mailer_sender = 'naoresponda@rssaude.com.br'
  require 'devise/orm/active_record'
  config.case_insensitive_keys = [ :email ]
  config.strip_whitespace_keys = [ :email ]
  config.skip_session_storage = [:http_auth]
  config.stretches = Rails.env.test? ? 1 : 10
  config.reconfirmable = true
  config.password_length = 8..128
  config.reset_password_within = 6.hours
  config.sign_out_via = :get
end