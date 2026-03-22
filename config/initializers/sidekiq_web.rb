# frozen_string_literal: true

# Sidekiq Web Authentication
# Only configure if Sidekiq::Web is loaded (i.e., in the web server process, not Sidekiq worker)
if defined?(Sidekiq::Web)
  Sidekiq::Web.use(Rack::Auth::Basic) do |username, password|
    # In production, use proper authentication via Devise or environment variables
    # For now, using basic auth with environment variables
    ActiveSupport::SecurityUtils.secure_compare(
      ::Digest::SHA256.hexdigest(username),
      ::Digest::SHA256.hexdigest(ENV.fetch('SIDEKIQ_WEB_USERNAME', 'admin'))
    ) & ActiveSupport::SecurityUtils.secure_compare(
      ::Digest::SHA256.hexdigest(password),
      ::Digest::SHA256.hexdigest(ENV.fetch('SIDEKIQ_WEB_PASSWORD', 'password'))
    )
  end
end
