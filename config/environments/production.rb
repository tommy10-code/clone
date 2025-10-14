require "active_support/core_ext/integer/time"

Rails.application.configure do
  config.enable_reloading = false
  config.eager_load = true

  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true

  config.assets.compile = false

  # Sprockets が app/assets/builds を探せるようにする
  config.assets.paths << Rails.root.join("app/assets/builds")

  # Render で静的ファイル配信を有効化する
  config.public_file_server.enabled = ENV["RAILS_SERVE_STATIC_FILES"].present?

  # Tailwind を使っている場合は圧縮器を無効化するのが無難
  config.assets.css_compressor = nil

  config.active_storage.service = :amazon

  config.force_ssl = true

  config.logger = ActiveSupport::Logger.new(STDOUT)
  .tap  { |logger| logger.formatter = ::Logger::Formatter.new }
  .then { |logger| ActiveSupport::TaggedLogging.new(logger) }

  # Prepend all log lines with the following tags.
  config.log_tags = [ :request_id ]

  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info")
  config.action_mailer.perform_caching = false
  config.i18n.fallbacks = true
  config.active_support.report_deprecations = false
  config.active_record.dump_schema_after_migration = false
  config.active_record.attributes_for_inspect = [ :id ]

  config.active_storage.service = :amazon

  config.action_mailer.default_url_options = {
    host: "dokodate.jp",
    protocol: "https"
  }

  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address:              "smtp.gmail.com",
    port:                 587,
    domain:               "dokodate.jp",
    user_name:            ENV["GMAIL_ADDRESS"],
    password:             ENV["GMAIL_APP_PASSWORD"],
    authentication:       :plain,
    enable_starttls_auto: true,
    open_timeout: 30,
    read_timeout: 30
  }
end
