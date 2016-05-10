require 'test_helper'

class DocumentsControllerTest < ActionController::TestCase

  setup do
    @user = create(:user)
    log_user_in(@user)
  end

  ####### SHOWING DETAILS AND FORMS ###########

  should "show new document form" do
    student = create(:student)
    xhr :get, :new, student_id: student.id

    document = assigns(:document)
    assert document, "Document should be assigned"
    assert_equal student.id, document.attachable_id
    assert_template :new
  end

  should "create one new document" do
    student = create(:student)

    assert_difference "Document.count", 1 do
      xhr :post, :create, student_id: student.id, document: attributes_for(:document)
    end

    document = assigns(:document)
    assert document, "Document should be assigned"
    assert_equal @user.id, document.user_id, "current user is the uploaded"
    assert_equal student.id, document.attachable_id, "The student id is set"
    assert_template :create

  end

  ## EDITING AND UPDATING ##
  should "show edit document form" do
    student = create(:student)
    document = create(:document, user: @user, attachable: student)

    xhr :get, :edit, student_id: student.id, id: document.id

    document = assigns(:document)
    assert document, "Document should be assigned"
    assert_template :edit
  end

end
