# frozen_string_literal: true

DatabaseCleaner.strategy = :transaction
DatabaseCleaner.clean_with(:truncation)

module Minitest
  module Rails
    module ActionController
      class TestCase
        def setup
          DatabaseCleaner.start
        end

        def teardown
          DatabaseCleaner.clean
        end
      end
    end
  end
end
