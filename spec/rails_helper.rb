# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'
require 'capybara/rspec'
require 'capybara-screenshot/rspec'
require 'fileutils'
require 'webmock/rspec'

# Add additional requires below this line. Rails is not loaded until this point!

# WebMock configuration
WebMock.disable_net_connect!(allow_localhost: true, allow: [ 'selenium:4444', 'care.lvh.me:3001', 'localhost:3001', 'rails-test:3001' ])

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
Rails.root.glob('spec/support/**/*.rb').sort_by(&:to_s).each { |f| require f }

# Checks for pending migrations and applies them before tests are run.
# If you are not using ActiveRecord, you can remove these lines.
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end
RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_paths = [
    Rails.root.join('spec/fixtures')
  ]

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # You can uncomment this line to turn off ActiveRecord support entirely.
  # config.use_active_record = false

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, type: :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://rspec.info/features/6-0/rspec-rails
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")

  # System test configuration
  config.before(:each, type: :system) do
    driven_by :rack_test
    # Use the Docker service name directly for Docker tests
    if ENV['DOCKER-TEST']
      if File.exist?(Rails.root.join('config', 'certs', 'key.pem')) && File.exist?(Rails.root.join('config', 'certs', 'cert.pem'))
        Capybara.app_host = "https://rails-test:3001"
      else
        Capybara.app_host = "http://rails-test:3001"
      end
    else
      if File.exist?(Rails.root.join('config', 'certs', 'key.pem')) && File.exist?(Rails.root.join('config', 'certs', 'cert.pem'))
        Capybara.app_host = "https://care.lvh.me:3001"
      else
        Capybara.app_host = "http://care.lvh.me:3001"
      end
    end
  end

  config.before(:each, :js, type: :system) do
    if ENV['DOCKER-TEST']
      driven_by :remote_chrome
    else
      driven_by :selenium_chrome_headless
    end
    # Use the Docker service name directly for Docker tests
    if ENV['DOCKER-TEST']
      if File.exist?(Rails.root.join('config', 'certs', 'key.pem')) && File.exist?(Rails.root.join('config', 'certs', 'cert.pem'))
        Capybara.app_host = "https://rails-test:3001"
      else
        Capybara.app_host = "http://rails-test:3001"
      end
    else
      if File.exist?(Rails.root.join('config', 'certs', 'key.pem')) && File.exist?(Rails.root.join('config', 'certs', 'cert.pem'))
        Capybara.app_host = "https://care.lvh.me:3001"
      else
        Capybara.app_host = "http://care.lvh.me:3001"
      end
    end
  end
end

# Capybara Screenshot configuration
Capybara::Screenshot.prune_strategy = :keep_last_run
Capybara::Screenshot.append_timestamp = false

# Ensure screenshot directory exists
screenshot_dir = Rails.root.join('tmp', 'capybara')
FileUtils.mkdir_p(screenshot_dir) unless Dir.exist?(screenshot_dir)

# Capybara configuration
Capybara.configure do |config|
  config.default_max_wait_time = 30
  config.default_normalize_ws = true
  config.ignore_hidden_elements = true
  config.visible_text_only = true
  config.match = :prefer_exact
  config.exact = true

  # Configure for Docker environment with HTTPS
  if ENV['SELENIUM_DRIVER_URL']
    # Don't start a server, use the external one
    config.run_server = false

    # Use the Docker service name directly for Docker tests
    if ENV['DOCKER-TEST']
      if File.exist?(Rails.root.join('config', 'certs', 'key.pem')) && File.exist?(Rails.root.join('config', 'certs', 'cert.pem'))
        config.app_host = "https://rails-test:3001"
      else
        config.app_host = "http://rails-test:3001"
      end
    else
      if File.exist?(Rails.root.join('config', 'certs', 'key.pem')) && File.exist?(Rails.root.join('config', 'certs', 'cert.pem'))
        config.app_host = "https://care.lvh.me:3001"
      else
        config.app_host = "http://care.lvh.me:3001"
      end
    end
  end
end
