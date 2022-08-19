DatabaseCleaner.strategy = :transaction
DatabaseCleaner.clean_with(:truncation)

class Minitest::Rails::ActionController::TestCase
  def setup
    DatabaseCleaner.start
  end

  def teardown
    DatabaseCleaner.clean
  end
end
