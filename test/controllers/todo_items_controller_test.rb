require 'test_helper'

class TodoItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @manager_user = create(:user, role: User::ADMIN)
    log_user_in(@manager_user)
    @todo_list = create(:todo_list)
    @item = create(:item)
  end

  should 'show new form for scan item' do
    get new_todo_list_todo_item_path(@todo_list), xhr: true
    assert_response :success
  end

  should 'create a new scann_list' do
    assert_difference 'TodoItem.count', 1 do
      post todo_list_todo_items_path(@todo_list), xhr: true,
                                                  params: { todo_item: { summary: 'whaterver', item_id: @item.id } }
      todo_item = assigns(:todo_item)
      assert todo_item, 'Todo List was not assigned'
      assert_equal 0, todo_item.errors.size, "There should be no errors, #{todo_item.errors.messages}"
      assert_equal todo_item.created_by, @manager_user, 'User should be manager user'
      assert_equal todo_item.item.id, @item.id, 'Items should match'
      assert_equal todo_item.todo_list.id, @todo_list.id, 'Todo Lists should match'
      assert_equal TodoItem::STATUS_NEW, todo_item.status, 'Status should be new'

      assert_response :success
    end
  end

  should 'remove an existing todo_list' do
    todo_item = create(:todo_item, todo_list_id: @todo_list.id)

    assert_difference 'TodoItem.count', -1 do
      delete todo_list_todo_item_path(@todo_list, todo_item), xhr: true
      assert_response :success
    end
  end
end
