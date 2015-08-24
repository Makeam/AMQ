require 'rails_helper'
require 'capybara/poltergeist'

RSpec.configure do |config|
  Capybara.javascript_driver = :poltergeist

  config.use_transactional_fixtures = false

  config.include AcceptanceMacros, type: :feature
  config.include SphinxHelpers, type: :feature

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
    # Ensure sphinx directories exist for the test environment
    ThinkingSphinx::Test.init
    # Configure and start Sphinx, and automatically
    # stop Sphinx at the end of the test suite.
    ThinkingSphinx::Test.start_with_autostop
  end
  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end
  config.before(:each, sphinx: true) do
    DatabaseCleaner.strategy = :truncation
    # Index data when running an acceptance spec.
    index #if example.metadata[:js]
  end
  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end
  config.before(:each) do
    DatabaseCleaner.start
  end
  config.after(:each) do
    DatabaseCleaner.clean
  end
end
