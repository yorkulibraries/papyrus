require 'test_helper'

class ItemCourseConnectionTest < ActiveSupport::TestCase
  should 'list ItemCourseConnections' do
    item = create(:item)
    create_list(:item_course_connection, 10, item:)

    assert_equal 10, item.courses.size, 'there are 10 courses'
  end

  should 'not allow duplicate item course connections' do
    item = create(:item)
    course = create(:course)

    course.add_item(item)

    assert_no_difference 'ItemCourseConnection.count' do
      course.add_item(item)
    end
  end
end
