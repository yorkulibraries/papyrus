# frozen_string_literal: true

require 'test_helper'

module Students
  class BulkRenewItemsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @student = create :student
      @admin_user = create :user, role: User::ADMIN
      log_user_in @admin_user
    end

    should 'show items to be renewed' do
      item = create :item

      item.assign_to_student @student, nil
      assert @student.items.size == 1

      get new_student_bulk_renew_items_path @student
      assert_response :success
    end

    should 'assign all items to a new date' do
      item = create :item
      item2 = create :item

      item.assign_to_student @student, 1.year.from_now.strftime('%Y-%m-%d')
      item2.assign_to_student @student, 2.years.from_now.strftime('%Y-%m-%d')

      post student_bulk_renew_items_path @student # params: { expires_on: { date: } }
      assert_redirected_to student_path @student

      assert_nil @student.item_connections.current.first.expires_on
      assert_nil @student.item_connections.current.last.expires_on

      new_expire_date = 3.years.from_now.strftime('%Y-%m-%d')
      post student_bulk_renew_items_path @student, params: { expires_on: { date: new_expire_date } }
      assert_redirected_to student_path @student

      assert_equal @student.item_connections.current.first.expires_on.strftime('%Y-%m-%d'), new_expire_date
      assert_equal @student.item_connections.current.last.expires_on.strftime('%Y-%m-%d'), new_expire_date
    end
  end
end
