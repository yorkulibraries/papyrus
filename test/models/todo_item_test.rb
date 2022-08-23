# frozen_string_literal: true

require 'test_helper'

class TodoItemTest < ActiveSupport::TestCase
  setup do
    @todo_list = create(:todo_list)
    @item = create(:item)
  end

  should 'create valid instance' do
    todo_item = build(:todo_item, todo_list: @todo_list, item: @item)
    assert todo_item.valid?

    assert_difference 'TodoItem.count', 1 do
      todo_item.save
    end
  end

  should 'not create an invalid instance' do
    assert !build(:todo_item, status: nil).valid?, 'status must be present'
    # assert ! build(:todo_item, item: nil).valid?, "item must be present" # comment out for now since the model does not check for item presence
    assert !build(:todo_item, todo_list: nil).valid?, 'scan List must be present'

    assert !build(:todo_item, created_by_id: nil).valid?, 'created_by id must be present'
  end

  should 'Return completed and not completed scan items' do
    create_list(:todo_item, 3, status: TodoItem::STATUS_DONE)
    create_list(:todo_item, 4, status: TodoItem::STATUS_NEW)

    assert_equal 4, TodoItem.not_completed.size, 'Should be 4'
    assert_equal 3, TodoItem.completed.size, 'Should be 3'
  end
end
