require 'test_helper'

class ItemsControllerTest < ActionController::TestCase
  include Rails.application.routes.url_helpers


  setup do
     @manager_user = create(:user, :role => User::MANAGER)
     @student_user = create(:student)

     log_user_in(@manager_user)
  end

  #### ASSIGNING AND WITHHOLDING TESTS ########

  should "withhold an item from student" do
     @item = create(:item)

     @item.assign_to_student(@student_user)

     assert_difference "ItemConnection.count", -1 do
        post :withhold_from_student, {:id => @item.id, :student_id => @student_user.id }
     end

     assert_response :redirect
     assert_redirected_to item_path(@item)
  end

  should "assign item to students" do
    @item = create(:item)

    student_1 = create(:student)
    student_2 = create(:student)

    assert_difference "ItemConnection.count", 3 do
      post :assign_to_students, { :id => @item.id, :student_ids => "#{student_1.id},#{student_2.id},#{@student_user.id}", :expires_on => { :date => 1.year.from_now} }
    end

    assert_response :redirect
    assert_redirected_to item_path(@item)
  end

  should "assign one or more items to one student" do
    @item = create(:item)

    item_1 = create(:item)

    assert_difference "ItemConnection.count", 2 do
      post :assign_many_to_student, {:item_ids => "#{item_1.id},#{@item.id}", :student_id => @student_user.id, :expires_on => {:date => 1.year.from_now}}
    end

    assert_response :redirect
    assert_redirected_to student_path(@student_user)
  end

  ##### ACQUISITION TESTS ########

  should "create an Acquisition Request when creating a new item and the checkbox is checked" do
    item_attrs = attributes_for(:item)

    assert_difference "AcquisitionRequest.count", 1 do
      post :create, :item => item_attrs, :create_acquisition_request => "yes"
    end

    request = assigns(:acquisition_request)
    item = assigns(:item)
    assert request
    assert_equal @manager_user.id, request.requested_by.id
    assert_equal item.id, request.item.id

  end

  should "show acquisition requests for the item" do
    @item = create(:item)

    create(:acquisition_request, :item => @item, :fulfilled => true) # fulfilled
    create(:acquisition_request, :item => @item, :fulfilled => false) # pending
    create(:acquisition_request, :item => @item, :fulfilled => false, :cancelled => true) # cancelled

    get :acquisition_requests, :id => @item.id

    pending = assigns(:pending_acquisition_requests)
    fulfilled = assigns(:fulfilled_acquisition_requests)
    cancelled = assigns(:cancelled_acquisition_requests)

    assert_equal 1, pending.size, "pending"
    assert_equal 1, fulfilled.size, "fulfilled"
    assert_equal 1, cancelled.size, "cancelled"

  end

  #### DISPLAY TESTS #######

  should "show a list of items default: sort by date" do
    create(:item, :title => "a year ago",  :created_at => Date.today - 1.year)
    create(:item, :title => "a month ago", :created_at => Date.today - 2.months)
    create(:item, :title => "6 moths ago", :created_at => Date.today - 6.months)

    get :index

    assert_response :success
    items = assigns(:items)

    assert_equal "a month ago", items.first.title, "First should be a month ago"
    assert_equal "a year ago", items.last.title, "Last should be a year ago"
  end


  should "display alphabetical order of items if params[:order] == alpha" do
     create(:item, :title => "year ago",  :created_at => Date.today - 1.year)
     create(:item, :title => "month ago", :created_at => Date.today - 2.months)
     create(:item, :title => "a first item", :created_at => Date.today - 6.months)


     get :index, order: "alpha"

     assert_response :success
     alpha_items = assigns(:items)
     assert_equal "a first item", alpha_items.first.title


     get :index

     assert_response :success
     by_date_items = assigns(:items)
     assert_equal "month ago", by_date_items.first.title
  end

  should "show item details page" do
    item = create(:item)

    get :show, id: item.id

    assert_response :success
    assert_template :show

    item = assigns(:item)
    assert_not_nil item, "Item was set"
  end


  #### CREATE AND UPDATE TESTS ####

  should "show new form if no vufind id is present" do
    get :new

    item = assigns(:item)
    assert_template :new
    assert item.title.blank?, "Title is not set"
  end



  should "create a new item" do

    assert_difference "Item.count", 1 do
      post :create, item: attributes_for(:item).except(:created_at)
      item = assigns(:item)
      assert_response :redirect, "Should redirect to item details page"
      assert_equal 0, item.errors.count, "NO error messages"
      assert_redirected_to item, "redirect to item page"
    end

    item = assigns(:item)

    assert_equal @manager_user.id, item.user.id, "Assigned created by user"
  end

  should "create an item and acquisition request if parameter is present" do
    assert_difference ["Item.count", "AcquisitionRequest.count"], 1 do
       post :create, item: attributes_for(:item).except(:created_at), create_acquisition_request: "yes"
    end

    acquisition_request = assigns(:acquisition_request)
    item = assigns(:item)
    assert_equal @manager_user, acquisition_request.requested_by
    assert_equal item, acquisition_request.item

  end

  should "show edit form" do
    item = create(:item)

    get :edit, id: item.id

    assert_template :edit
    assert assigns(:item)
  end

  should "update an existing item" do

    item = create(:item, title: "old", author: "him", user: @manager_user)

    post :update, id: item.id, item: { title: "new", author: "me"}

    item = assigns(:item)
    assert_response :redirect
    assert_equal 0, item.errors.count, "Should be no errors"
    assert_redirected_to item
    assert_equal @manager_user, item.user, "User id hasn't changed"

  end

  should "delete an item, just set the deleted flag" do
    item = create(:item)
    assert_difference "Item.count", -1 do
      post :destroy, id: item.id
    end
    assert_redirected_to items_path, "Redirects to items listing"
  end

end
