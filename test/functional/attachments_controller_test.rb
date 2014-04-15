require 'test_helper'

class AttachmentsControllerTest < ActionController::TestCase
  
  setup do
    @user = create(:user)
    log_user_in(@user)
  end
  
  ####### SHOWING DETAILS AND FORMS ###########
  
  should "show new document form" do
    item = create(:item)
    get :new, item_id: item.id
    
    attachment = assigns(:attachment)
    assert_equal item.id, attachment.item_id
    assert_template :new
  end
  
  should "show new url form if params[url]" do
    item = create(:item)
    get :new, item_id: item.id, url: true
    assert_template :new_url
  end
  
  
  should "show edit form" do
    item = create(:item)
    attachment = create(:attachment, item: item)
    
    get :edit, item_id: item.id, id: attachment.id
    
    assert_template :edit
  end
  
  should "show edit form for url" do
    item = create(:item)
    attachment = create(:attachment, item: item, is_url: true, url: "http:://WOOT.com")
    
    get :edit, item_id: item.id, id: attachment.id
    assert_template :edit
    assert_template :form_url, "Should be edit with form url partial "
  end
  
  ######### CREATING AND UPDATING ############
  should "create one new attachment" do
    item = create(:item)
    
    assert_difference "Attachment.count", 1 do
      post :create, item_id: item.id, attachment: attributes_for(:attachment)
    end
    
    attachment = assigns(:attachment)
    assert_equal @user.id, attachment.user_id, "current user is the uploaded"
    assert_equal item.id, attachment.item_id, "The item id is set"
    assert_redirected_to item_path(item), "Redirects to item after success"
    
  end
  
  should "createa a URL attachment" do 
    item = create(:item)
    
    assert_difference "Attachment.count", 1 do
      post :create, item_id: item.id, attachment: { name: "NAME", url: "http:://wwwo.com", access_code_required: true }
      attachment = assigns(:attachment)
      assert_equal 0, attachment.errors.size, "No errors should be"
      assert attachment.is_url?, "SHould be a URL"
      assert_redirected_to item_path(item)
    end
  end
  
  should "update an existing file" do
    item = create(:item, item_type: Item::BOOK, title: "test")
    attachment = create(:attachment, name: "woot", item: item)
    
    post :update, item_id: item.id, id: attachment.id, attachment: { name: "new"}
    
    a = assigns(:attachment)
    assert_equal "new", a.name, "Name changed"
    
    
    post :update, item_id: item.id, id: attachment.id, attachment: { file: fixture_file_upload("test_picture.jpg", "image/jpg") }
    
    attachment = assigns(:attachment)

    assert attachment.file.url.ends_with?("test_picture.jpg"), "new file uploaded"        
    
    assert_redirected_to item_url(item), "Redirects back to item"
  end
  
  

  
  ##### DESTROYING ATTACHMENTS ######
  
  should "not destroy but set to deleted, but rename the file" do
    item = create(:item, item_type: Item::BOOK, title: "test")
    attachment = create(:attachment, name: "woot", item: item)
    
    old_filename = attachment.file.file.filename
    
    assert_no_difference "Attachment.count" do
      post :destroy, id: attachment.id, item_id: item.id
    end
  
    a = assigns(:attachment)
    assert a.deleted?, "Should have deleted flag set to true"
    #a.file.file.move_to(File.dirname(a.file.file.path) + "/deleted/" + a.id + "-" + a.file.file.filename)
    assert_equal a.file.to_s, "/#{a.file.store_dir}/deleted/#{a.id}-#{old_filename}"
    assert_redirected_to item_url(item), "Redirects back to item"
  end
  
  
  should "delete multiple attachments" do
    item = create(:item)
    list = create_list(:attachment, 5, item: item, deleted: false)
    
    assert_no_difference "Attachment.count" do
      post :delete_multiple, ids: [list[0].id, list[1].id, list[2].id], item_id: item.id
      assert_response :redirect
      assert_redirected_to item_path(item)
    end
    
    assert_equal item.attachments.deleted.size, 3, "Three deleted" 
    assert_equal item.attachments.available.size, 2, "Two not deleted"
  end
  
  
  ##### DOWNLOADING ATTACHMENT ########

  should "let you download attachment" do
    item = create(:item, item_type: Item::BOOK, title: "test")
    attachment = create(:attachment, name: "woot", item: item, file: fixture_file_upload("test_picture.jpg", "image/jpg") )           
     
    get :get_file, id: attachment.id, item_id: item.id
        
    assert_response :success
    assert_equal "binary", response.headers["Content-Transfer-Encoding"]
    assert_equal "attachment; filename=\"#{File.basename(attachment.file_url)}\"", response.headers["Content-Disposition"]
    assert_equal File.mime_type?("#{attachment.file.path}"), response.headers["Content-Type"]
    
  end

   
end
