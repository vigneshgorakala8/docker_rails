require 'simplecov'
SimpleCov.start 'rails' do
  enable_coverage :branch
  add_filter 'spec'
  add_filter 'public/vendor'
end

ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/retry'
require 'capybara/rails'
require 'capybara/rspec'
require 'capybara-screenshot/rspec'
require 'paper_trail/frameworks/rspec'

require 'webmock/rspec'
# WebMock.disable_net_connect!(allow_localhost: true, allow: ['chrome-server:4444'])
WebMock.disable_net_connect!(allow_localhost: true, allow: [ 'chrome-server:4444', 'care.lvh.me:3001', 'localhost:3001', 'rails-test:3001' ])


require 'sidekiq/testing'
Sidekiq::Testing.fake!
Sidekiq.logger.level = Logger::ERROR

key = Rails.root.join('config', 'certs', 'key.pem')
crt = Rails.root.join('config', 'certs', 'cert.pem')

OmniAuth.config.test_mode = true

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }




Capybara.configure do |config|
  config.default_max_wait_time = 30
  config.default_normalize_ws = true
  config.ignore_hidden_elements = true
  config.visible_text_only = true
  config.match = :prefer_exact
  config.exact = true


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

Capybara::Screenshot.prune_strategy = :keep_last_run

RSpec::Matchers.define_negated_matcher :not_change, :change
RSpec.configure do |config|
  config.order = "random"
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include Devise::Test::IntegrationHelpers, type: :request
  config.include FactoryBot::Syntax::Methods
  config.include Capybara::DSL
  config.raise_errors_for_deprecations!
  config.run_all_when_everything_filtered = true
  config.use_transactional_fixtures = false
  config.infer_spec_type_from_file_location!
  # config.filter_run_excluding :broken => true
  config.verbose_retry = true
  config.display_try_failure_messages = true

  config.before(:suite) do
    DatabaseCleaner.strategy = [ :truncation, except: %w[code] ]
    ENV['HOST_ENV'] = 'test'
    Rails.application.load_seed
  end

  config.before(:each) do
    Sidekiq::Worker.clear_all
    DatabaseCleaner.start
    FactoryBot.rewind_sequences
  end

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

  config.before(:each, type: :system, js: true) do
    if ENV['DOCKER-TEST']
      driven_by :remote_chrome
    else
      driven_by :chrome_js
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

  config.after(:each) do
    DatabaseCleaner.clean
  end
  config.after(:suite) do
    FileUtils.rm_rf(ActiveStorage::Blob.service.root)
  end

  if ENV['RETRY'] == "true"
    config.around :each do |example|
      example.run_with_retry retry: 3
    end
  end
end
