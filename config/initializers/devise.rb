# frozen_string_literal: true

Devise.setup do |config|
  # The secret key used by Devise. Devise uses this key to generate
  # random tokens. Changing this key will render invalid all existing
  # confirmation, reset password and unlock tokens in the database.
  # config.secret_key = 'your_secret_key_here'
  config.navigational_formats = ['*/*', :html]

  # Configure the e-mail address which will be shown in Devise::Mailer,
  # note that it will be overwritten if you use your own mailer class
  # with default "from" parameter.
  config.mailer_sender = 'please-change-me-at-config-initializers-devise@example.com'

  # Load and configure the ORM. Supports :active_record (default) and
  # :mongoid (bson_ext recommended) and others.
  require 'devise/orm/active_record'

  # Configure case-insensitive keys. These keys will be downcased upon creating a new user.
  config.case_insensitive_keys = [ :email ]

  # Configure whitespace stripping for authentication keys.
  config.strip_whitespace_keys = [ :email ]

  # Skip session storage for http authentication to make API stateless.
  config.skip_session_storage = [ :http_auth ]

  # If true, authentication will be done through request HTTP auth.
  config.http_authenticatable = [ :database ]

  # Configure the navigational formats Devise will respond to.
  config.navigational_formats = []

  # If you want to use email confirmation before allowing login.
  config.allow_unconfirmed_access_for = 0.days

  # The minimum password length for users.
  config.password_length = 6..128

  # Timeout the user session after a certain period of inactivity.
  config.timeout_in = 30.minutes

  # ==> OmniAuth
  # Add a new OmniAuth provider. Check the wiki for more information on setting
  # up on your models and hooks.
  # config.omniauth :github, 'APP_ID', 'APP_SECRET', scope: 'user,public_repo'
end
