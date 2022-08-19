require 'test_helper'

class TodoListTest < ActiveSupport::TestCase
  should 'create valid TodoList' do
    todo_list = build(:todo_list)
    assert todo_list.valid?
    assert_difference 'TodoList.count', 1 do
      todo_list.save
    end
  end

  should 'not create an invalid TodoList' do
    assert !build(:todo_list, name: nil).valid?, 'name must be present'
    assert !build(:todo_list, status: nil).valid?, 'status Type must be present'

    assert !build(:todo_list, created_by_id: nil).valid?, 'created_by id must be present'
  end

  should 'return assignee and/or creator name' do
    u = create(:user, name: 'John Doe')
    todo_list = create(:todo_list, created_by: u, assigned_to: u)

    assert_equal u.name, todo_list.assignee
    assert_equal u.name, todo_list.creator

    todo_list.assigned_to = nil

    assert_equal 'Unassigned', todo_list.assignee
  end

  should 'Return completed and not completed scan lists' do
    create_list(:todo_list, 3, status: TodoList::STATUS_DONE)
    create_list(:todo_list, 2, status: TodoList::STATUS_NEW)
    create_list(:todo_list, 2, status: TodoList::STATUS_IN_PROGRESS)

    assert_equal 4, TodoList.not_completed.size, 'Should be 4'
    assert_equal 3, TodoList.completed.size, 'Should be 3'
  end
end
