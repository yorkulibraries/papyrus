require 'test_helper'

class DocumentsControllerTest < ActionDispatch::IntegrationTest

  setup do
    @user = create(:user)
    log_user_in(@user)
    @student = create(:student)
  end

  ####### SHOWING DETAILS AND FORMS ###########

  should "show new document form" do

    get new_student_document_url(@student), xhr: true

    document = assigns(:document)
    assert document, "Document should be assigned"
    assert_equal @student.id, document.attachable_id
    assert_response :success
  end

  should "create one new document" do


    assert_difference "Document.count", 1 do
      post student_documents_url(@student),xhr: true, params: { document: attributes_for(:document) }
    end

    document = assigns(:document)
    assert document, "Document should be assigned"
    assert_equal @user.id, document.user_id, "current user is the uploaded"
    assert_equal @student.id, document.attachable_id, "The student id is set"
    assert_response :success

  end

  ## EDITING AND UPDATING ##
  should "show edit document form" do

    document = create(:document, user: @user, attachable: @student)

    get edit_student_document_url(@student, document), xhr: true

    document = assigns(:document)
    assert document, "Document should be assigned"
    assert_response :success
  end

end
