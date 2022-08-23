# frozen_string_literal: true

require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  context 'User with login and pw' do
    setup do
      Rails.configuration.is_using_login_password_authentication = true
      @manager_user = create(:user, role: User::MANAGER, password: '12345678')
      log_user_in(@manager_user)
    end

    should 'create a new user' do
      post users_path, params: { user: attributes_for(:user, password: '12345678') }
      assert_equal 2, User.count
    end
  end

  context 'User with SAML or Headers' do
    setup do
      @manager_user = create(:user, role: User::MANAGER)
      log_user_in(@manager_user)
    end

    should 'only set user to blocked when destroying one' do
      u = create(:user)

      assert_no_difference 'User.count' do
        delete user_path(u)
      end

      user = assigns(:user)
      assert_equal true, user.blocked?, 'User has been set to inactive'
      assert_redirected_to users_url, 'Redirected to users url'
    end

    should 'allow to deactivate user event if user has missing fields' do
      u = create(:user)
      u.email = nil
      u.save(validate: false)

      delete user_path(u)

      user = assigns(:user)
      assert_equal true, user.blocked?, 'User should be set to inactive'
    end

    should 'activate an inactive user' do
      u = create(:user, blocked: true)

      post activate_user_path(u)

      user = assigns(:user)
      assert !user.blocked?, 'User should be active'
      assert_redirected_to users_url, 'Redirects to users url'
    end

    should 'list all active non-student users' do
      create_list(:user, 2, blocked: false)
      create_list(:user, 2, role: User::STUDENT_USER, inactive: false)

      create_list(:user, 5, blocked: true)

      get users_path

      users = assigns(:users)
      assert_equal 3, users.count, 'Only 3 active users (2 + 1 logged in)'
    end

    should 'list all inactive non student users' do
      create_list(:user, 2, blocked: false)

      create_list(:user, 2, role: User::STUDENT_USER, inactive: true)
      create_list(:user, 5, blocked: true)

      get inactive_users_path

      users = assigns(:users)
      assert_equal 5, users.count, '5 inactive users'
    end

    should 'create a new user' do
      assert_difference 'User.count', 1 do
        post users_path, params: { user: attributes_for(:user) }
      end
    end

    should 'update an existing user' do
      u = create(:user, username: 'old')

      patch user_path(u), params: { user: { username: 'new' } }

      user = assigns(:user)
      assert_equal 'new', user.username, 'Updated username'
      assert_redirected_to users_url, 'redirects to users url'
    end

    should 'not create a user when fields are missing' do
      assert_no_difference 'User.count' do
        post users_path, params: { user: { email: 'woot@test.com' } }
      end
    end
  end
end
