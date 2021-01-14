require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Two2create
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    config.time_zone = 'Tokyo' # タイムゾーンを日本時間にする
    config.action_view.field_error_proc = Proc.new { |html_tag, instance| html_tag }  # エラーメッセージによるレイアウト崩れ防止
    config.i18n.default_locale = :ja  # エラーメッセージの日本語化
    # config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.yml').to_s]  # localesのymlファイル群を読み込むためのパスを通す
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s]
  end
end
