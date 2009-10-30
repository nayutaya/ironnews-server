# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_ironnews-server_session',
  :secret      => '47aa45307fb3c30e20a363c26b2c0439608ec3ef5bc8e77183835e186a0596cb4a66dc23988ed2ae1c7855d8a87e1867bd4e8aafde039d0f6f28a9006bcb39a2'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
