# frozen_string_literal: true

require 'test_helper'

class ItemsControllerTest < ActionDispatch::IntegrationTest
  include Rails.application.routes.url_helpers

  setup do
    @manager_user = create(:user, role: User::MANAGER)
    @student_user = create(:student)

    log_user_in(@manager_user)
  end

  #### ASSIGNING AND WITHHOLDING TESTS ########

  should 'withhold an item from student' do
    item = create(:item)

    item.assign_to_student(@student_user)

    assert_difference 'ItemConnection.count', -1 do
      delete withhold_from_student_item_url(item), params: { student_id: @student_user.id }
    end

    assert_response :redirect
    assert_redirected_to item_path(item)
  end

  should 'assign item to students' do
    item = create(:item)

    student_1 = create(:student)
    student_2 = create(:student)

    assert_difference 'ItemConnection.count', 3 do
      post assign_to_students_item_url(item),
           params: { student_ids: "#{student_1.id},#{student_2.id},#{@student_user.id}",
                     expires_on: { date: 1.year.from_now } }
    end

    assert_response :redirect
    assert_redirected_to item_path(item)
  end

  should 'assign one or more items to one student' do
    item = create(:item)

    item_1 = create(:item)

    assert_difference 'ItemConnection.count', 2 do
      post assign_many_to_student_items_url,
           params: { item_ids: "#{item_1.id},#{item.id}", student_id: @student_user.id,
                     expires_on: { date: 1.year.from_now } }
    end

    assert_response :redirect
    assert_redirected_to student_path(@student_user)
  end

  #### DISPLAY TESTS #######

  should 'show a list of items default: sort by date' do
    create(:item, title: 'a year ago',  created_at: Date.today - 1.year)
    create(:item, title: 'a month ago', created_at: Date.today - 2.months)
    create(:item, title: '6 moths ago', created_at: Date.today - 6.months)

    get items_path

    assert_response :success
    items = assigns(:items)

    assert_equal 'a month ago', items.first.title, 'First should be a month ago'
    assert_equal 'a year ago', items.last.title, 'Last should be a year ago'
  end

  should 'display alphabetical order of items if params[:order] == alpha' do
    create(:item, title: 'year ago', created_at: Date.today - 1.year)
    create(:item, title: 'month ago', created_at: Date.today - 2.months)
    create(:item, title: 'a first item', created_at: Date.today - 6.months)

    get items_path, params: { order: 'alpha' }

    assert_response :success
    alpha_items = assigns(:items)
    assert_equal 'a first item', alpha_items.first.title

    get items_path

    assert_response :success
    by_date_items = assigns(:items)
    assert_equal 'month ago', by_date_items.first.title
  end

  should 'show item details page' do
    item = create(:item)

    get item_path(item)

    assert_response :success

    item = assigns(:item)
    assert_not_nil item, 'Item was set'
  end

  #### CREATE AND UPDATE TESTS ####

  should 'show new form if no vufind id is present' do
    get new_item_path
    assert_response :success

    item = assigns(:item)
    assert item.title.blank?, 'Title is not set'
  end

  should 'create a new item' do
    assert_difference 'Item.count', 1 do
      post items_path, params: { item: attributes_for(:item).except(:created_at) }
      item = assigns(:item)
      assert_response :redirect, 'Should redirect to item details page'
      assert_equal 0, item.errors.count, 'NO error messages'
      assert_redirected_to item, 'redirect to item page'
    end

    item = assigns(:item)

    assert_equal @manager_user.id, item.user.id, 'Assigned created by user'
  end

  should 'create an item and acquisition request if parameter is present' do
    reason = 'Reason'
    note = 'Note'

    assert_difference ['Item.count', 'AcquisitionRequest.count'], 1 do
      post items_path, params: { create_acquisition_request: 'yes',
                                 item: { title: 'Test', item_type: 'BOOK', unique_id: '12323',
                                         acquisition_request: { acquisition_reason: reason, note: } } }

      #  item = assigns(:item)
      #  assert_equal 0, item.errors.size, "Item Errors: #{item.errors.messages}"
    end

    item = assigns(:item)
    acquisition_request = assigns(:acquisition_request)
    assert_equal @manager_user, acquisition_request.requested_by
    assert_equal item.id, acquisition_request.item.id
    assert_equal reason, acquisition_request.acquisition_reason
    assert_equal note, acquisition_request.note
  end

  should 'show edit form' do
    item = create(:item)

    get edit_item_path(item)

    assert_response :success
    assert assigns(:item)
  end

  should 'update an existing item' do
    item = create(:item, title: 'old', author: 'him', user: @manager_user)

    patch item_path(item), params: { item: { title: 'new', author: 'me' } }

    item = assigns(:item)
    assert_response :redirect
    assert_equal 0, item.errors.count, 'Should be no errors'
    assert_redirected_to item
    assert_equal @manager_user, item.user, "User id hasn't changed"
  end

  should 'delete an item, just set the deleted flag' do
    item = create(:item)
    assert_difference 'Item.count', -1 do
      delete item_path(item)
    end
    assert_redirected_to items_path, 'Redirects to items listing'
  end
end
