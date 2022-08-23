# frozen_string_literal: true

require 'test_helper'

class SharedAccessCodesControllerTest < ActionDispatch::IntegrationTest
  context 'AS a MANAGER USER' do
    setup do
      @manager_user = create(:user, role: User::MANAGER)
      log_user_in(@manager_user)
    end

    should 'show all non-expired shared codes' do
      create_list(:access_code, 2, expires_at: 2.days.ago)
      create_list(:access_code, 3, expires_at: 2.days.from_now, shared: true)
      create_list(:access_code, 5, expires_at: 2.days.from_now, shared: false)

      get shared_access_codes_path
      assert_response :success

      access_codes = assigns(:access_codes)
      assert_not_nil access_codes, "Shouldn't be nil"
      assert_equal 3, access_codes.size, 'Should only be 3 shared, non-expired codes'
    end

    should 'show new form for shared access_code' do
      get new_shared_access_code_path
      assert_response :success
    end

    should 'create a new shared access code' do
      assert_difference 'AccessCode.shared.count', 1 do
        post shared_access_codes_path,
             params: { access_code: { for: 'whaterver', code: 'code', expires_at: '2014-10-10' } }
        code = assigns(:access_code)
        assert_equal 0, code.errors.size, 'There should be no errors'
        assert_nil code.student, 'Student should be nil'
        assert_equal code.created_by.id, @manager_user.id, 'Created by was assigned'
        assert code.shared, 'Should be shared'

        assert_redirected_to shared_access_codes_path, 'Should redirect back to shared access codes list'
      end
    end

    should 'remove an existing shared access code' do
      code = create(:access_code, student: @student, shared: true)

      assert_difference 'AccessCode.shared.count', -1 do
        delete shared_access_code_path(code)
        assert_redirected_to shared_access_codes_path, 'Should redirect back to shared codes list'
      end
    end
  end

  context 'As a COORDINATOR USER' do
    setup do
      @user = create(:user, role: User::COORDINATOR)
      log_user_in(@user)
    end

    should 'show all non-expired shared codes' do
      create_list(:access_code, 2, expires_at: 2.days.ago)
      create_list(:access_code, 3, expires_at: 2.days.from_now, shared: true)
      create_list(:access_code, 5, expires_at: 2.days.from_now, shared: false)

      get shared_access_codes_path
      assert_response :success

      access_codes = assigns(:access_codes)
      assert_not_nil access_codes, "Shouldn't be nil"
      assert_equal 3, access_codes.size, 'Should only be 3 shared, non-expired codes'
    end
  end
end
