require 'capybara/rspec'
require 'selenium/webdriver'

Capybara.register_driver :remote_chrome do |app|
  chrome_options = Selenium::WebDriver::Chrome::Options.new
  chrome_options.args << 'headless'
  chrome_options.args << 'disable-gpu'
  chrome_options.args << 'no-sandbox'
  chrome_options.args << 'disable-dev-shm-usage'
  chrome_options.args << 'ignore-certificate-errors'
  chrome_options.args << 'ignore-ssl-errors'
  chrome_options.args << 'ignore-certificate-errors-spki-list'
  chrome_options.args << 'disable-web-security'
  chrome_options.args << 'allow-running-insecure-content'
  chrome_options.args << 'window-size=1400,1400'
  chrome_options.args << 'remote-debugging-port=9222'

  Capybara::Selenium::Driver.new(
    app,
    browser: :remote,
    url: 'http://chrome-server:4444/wd/hub',
    capabilities: chrome_options
  )
end

Capybara.javascript_driver = :remote_chrome
Capybara.default_max_wait_time = 5
