# config/fetch_secret.rb

# Extends the Rails application to include a unified secret-fetching method.
# This looks in Rails credentials first, then falls back to ENV.
#
# ✅ Usage:
#   Rails.application.fetch_secret(:api_key)
#   Rails.application.fetch_secret(:aws, :s3, :access_key_id)
#
# ✅ ENV fallback uses all keys uppercased and joined with "_":
#   e.g., ENV['AWS_S3_ACCESS_KEY_ID']

# lib/fetch_secret.rb

module FetchSecretExtension
  def fetch_secret(*keys)
    raise ArgumentError, "Must provide at least one key" if keys.empty?

    cred_keys = keys.map(&:to_sym)
    env_key   = keys.map(&:to_s).map(&:upcase).join("_")

    value = credentials.dig(*cred_keys) if Rails.env.development? || Rails.env.test?

    value || ENV[env_key]
  end
end
