require 'capybara/rspec'
require 'capybara/rails'

Capybara.register_driver :chrome do |app|
  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
    'chromeOptions' => {
      'args' => ['headless', 'no-sandbox', 'disable-gpu', 'window-size=1920,1080']
    }
  )

  Capybara::Selenium::Driver.new(app, browser: :chrome, desired_capabilities: capabilities)
end

Capybara.ignore_hidden_elements = false
Capybara.default_wait_time = 5


Capybara.javascript_driver = :chrome
