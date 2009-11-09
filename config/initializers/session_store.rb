# Be sure to restart your server when you modify this file.

secret_filepath = File.join(RAILS_ROOT, "config/secret.txt")
if File.exist?(secret_filepath)
  secret = File.open(secret_filepath) { |file| file.read }.strip
end

if secret.blank?
  secret = 128.times.map { rand(16).to_s(16) }.join
  File.open(secret_filepath, "w") { |file| file.write(secret) }
end

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key    => "_ironnews_session",
  :secret => secret,
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
