# frozen_string_literal: true

require 'test_helper'

class ItemConnectionTest < ActiveSupport::TestCase
  should 'show current connections only or expired connections' do
    student = create(:student)

    create_list(:item_connection, 5, student:, expires_on: Date.today + 1.year)
    create_list(:item_connection, 4, student:, expires_on: Date.today - 1.year)

    assert_equal 5, ItemConnection.current.size
    assert_equal 4, ItemConnection.expired.size
  end

  should 'show as current connections if expires_on is nil' do
    student = create(:student)

    create_list(:item_connection, 5, student:, expires_on: nil)
    create_list(:item_connection, 4, student:, expires_on: Date.today - 1.year)

    assert_equal 5, ItemConnection.current.size
  end
end
