require 'rake'
require 'test_helper'

class ImporterTaskTest < ActiveSupport::TestCase
  setup do
    load Rails.root.join('lib', 'tasks', 'importer.rake')
    Rake::Task.define_task(:environment)

    ENV['DEBUG'] = 'true'
  end
end
