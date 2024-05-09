Sentry.init do |config|
  config.dsn = ENV['SENTRY_DSN']
  config.enable_tracing = true
  config.breadcrumbs_logger = [:active_support_logger, :http_logger]
end