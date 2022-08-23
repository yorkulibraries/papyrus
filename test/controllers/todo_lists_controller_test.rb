# frozen_string_literal: true

require 'test_helper'

class TodoListsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @manager_user = create(:user, role: User::ADMIN)
    log_user_in(@manager_user)
  end

  should 'show scan lists' do
    create_list(:todo_list, 4)
    create_list(:todo_list, 3, status: TodoList::STATUS_IN_PROGRESS)
    create_list(:todo_list, 5, status: TodoList::STATUS_DONE)

    get todo_lists_path
    assert_response :success

    todo_lists = assigns(:todo_lists)

    assert_not_nil todo_lists, "Shouldn't be nil"

    assert_equal 7, todo_lists.size, 'Should only be 7, not completed ones'

    get todo_lists_path, params: { which: 'done' }
    assert_response :success
    todo_lists = assigns(:todo_lists)
    assert_equal 5, todo_lists.size, 'Should be 5 complted'
  end

  should 'show new form for scan list' do
    get new_todo_list_path
    assert_response :success
  end

  should 'create a new scann_list' do
    assert_difference 'TodoList.count', 1 do
      post todo_lists_path, params: { todo_list: { name: 'whaterver' } }
      todo_list = assigns(:todo_list)
      assert todo_list, 'Todo List was not assigned'
      assert_equal 0, todo_list.errors.size, "There should be no errors, #{todo_list.errors.messages}"
      assert_equal todo_list.created_by, @manager_user, 'User should be manager user'
      assert_equal TodoList::STATUS_NEW, todo_list.status, 'Status should be new'

      assert_redirected_to todo_list_path(todo_list), 'Should redirect back to scan list'
    end
  end

  should 'remove an existing todo_list' do
    todo_list = create(:todo_list)

    assert_difference 'TodoList.count', -1 do
      delete todo_list_path(todo_list)
      assert_redirected_to todo_lists_path, 'Should redirect back to todo_lists'
    end
  end
end
