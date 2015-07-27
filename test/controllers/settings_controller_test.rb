require 'test_helper'

class SettingsControllerTest < ActionController::TestCase
  setup do
    @manager_user = create(:user, role: User::ADMIN)
    log_user_in(@manager_user)
  end

  should "show settings forms" do
    get :general
    assert_template :general

    get :email
    assert_template :email

    get :item
    assert_template :item

    get :system
    assert_template :system

    get :bib_search
    assert_template :bib_search
  end

  should "update settings upon submission" do
    PapyrusSettings.app_name = "test"

    assert_equal "test", PapyrusSettings.app_name, "Precondition, name is test"
    put :update, setting: { app_name: "papyrus" }
    assert_equal "papyrus", PapyrusSettings.app_name, "Should have saved a new name"
    assert_redirected_to general_settings_path, "Should go back to the form"
  end

  should "redirect to proper page" do
    put :update, setting: { app_name: "papyrus" }, return_to: "item"
    assert_redirected_to item_settings_path

    put :update, setting: { app_name: "papyrus" }, return_to: "bib_search"
    assert_redirected_to bib_search_settings_path

    put :update, setting: { app_name: "papyrus" }, return_to: "email"
    assert_redirected_to email_settings_path

    put :update, setting: { app_name: "papyrus" }, return_to: "system"
    assert_redirected_to system_settings_path

    put :update, setting: { app_name: "papyrus" }, return_to: "general"
    assert_redirected_to general_settings_path

  end

end
