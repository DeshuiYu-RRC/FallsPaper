# frozen_string_literal: true

# Devise configuration
Devise.setup do |config|
  # Mailer sender
  config.mailer_sender = 'noreply@fallspaper.com'

  # ORM configuration
  require 'devise/orm/active_record'

  # Case insensitive keys
  config.case_insensitive_keys = [:email]

  # Strip whitespace
  config.strip_whitespace_keys = [:email]

  # Skip session storage for certain strategies
  config.skip_session_storage = [:http_auth]

  # Stretches for encryption
  config.stretches = Rails.env.test? ? 1 : 12

  # Reconfirmable
  config.reconfirmable = false

  # Expire password after some time (nil = never)
  config.expire_all_remember_me_on_sign_out = true

  # Password length
  config.password_length = 6..128

  # Email regex
  config.email_regexp = /\A[^@\s]+@[^@\s]+\z/

  # Reset password within
  config.reset_password_within = 6.hours

  # Sign out via
  config.sign_out_via = :delete

  # Responder
  config.responder.error_status = :unprocessable_entity
  config.responder.redirect_status = :see_other
end
