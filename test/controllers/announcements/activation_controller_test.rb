require 'test_helper'

class Announcements::ActivationControllerTest < ActionDispatch::IntegrationTest
  setup do
    @manager_user = create(:user, role: User::MANAGER)
    log_user_in(@manager_user)
  end


  should "show different announcement" do
    a = create(:announcement, active: false)

    assert !a.active?

    patch announcement_activation_url(a)
    assert_response :redirect

    a.reload
    assert a.active?

    delete announcement_activation_url(a)
    assert_response :redirect

    a.reload
    assert !a.active?

  end
end
