require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module AtmExercise
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
  end
end

module Trailblazer
  class Railtie < Rails::Railtie
    def self.autoload_crud_operations(app)
      Dir.glob("app/concepts/**/operations.rb") do |f|
        path  = f.sub("app/concepts/", "")
        model = path.sub("/operations.rb", "")

        require_dependency "#{app.root}/app/models/#{model}" # load the model file, first (thing.rb).
        require_dependency "#{app.root}/#{f}" # load app/concepts/{concept}/crud.rb (Thing::Create, Thing::Update, and so on).
      end
    end

    # thank you, http://stackoverflow.com/a/17573888/465070
    initializer 'trailblazer.install', after: :load_config_initializers do |app|
      # the trb autoloading has to be run after initializers have been loaded, so we can tweak inclusion of features in
      # initializers.
      ActionDispatch::Reloader.to_prepare do
        Trailblazer::Railtie.autoload_crud_operations(app)
      end
    end
  end
end