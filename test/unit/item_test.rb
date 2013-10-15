require 'test_helper'

class ItemTest < ActiveSupport::TestCase
 
   
   should "create a valid Item" do
     item = build(:item)
     assert_difference "Item.count", 1 do
       item.save
     end
   end
   
   should "not create an invalid item"  do
     
     assert ! build(:item, title: nil).valid?, "Title must be present"
     assert ! build(:item, unique_id: nil).valid?, "Unique ID must be present"
     assert ! build(:item, item_type: nil).valid?, "Item Type must be present"         
     
     create(:item, unique_id: "12345") 
     assert ! build(:item, unique_id: "12345").valid?, "Unique id must be unique"
   end
 
 
   should "order items by date or alphabetically" do
     create(:item, :title => "year ago",  :created_at => Date.today - 1.year)
     create(:item, :title => "month ago", :created_at => Date.today - 2.months)
     create(:item, :title => "a first item", :created_at => Date.today - 6.months)
   
     by_date_items = Item.by_date
   
     assert_equal "month ago", by_date_items.first.title
   
   
     alpha_items = Item.alphabetical
   
     assert_equal "a first item", alpha_items.first.title
      
   end
 
 
   should "display current students only, not expired ones" do
     item = create(:item)
   
     create_list(:item_connection, 5, :item => item, :expires_on => Date.today + 1.year)
     create_list(:item_connection, 4, :item => item, :expires_on => Date.today - 1.year)
   
     assert_equal 5, item.students.size, "Only 5 students should have been assiged through item_connections"
   
   end
  
 
  ### ASSITING AND REMOVING ITEMS FROM STUDENT ##
   context "assigning/ removing items to/from students" do
   
     setup do
       @student = create(:student)
       @item = create(:item)
     end

        
     ## ITEM ASSIGNMENT ###
   
     should "be assigned to student" do     
       assert_difference "ItemConnection.count", 1 do
         @item.assign_to_student(@student, Date.today)
       end             
     
     end

     should "not assign to student if item already assigned and not expired" do
        expires_on = Date.today + 1.year
        @item.assign_to_student(@student, expires_on)
     
        assert_no_difference "ItemConnection.count", "No new item connection should be created" do
          @item.assign_to_student(@student, Date.today)
        end                
        
     end
   
     should "re assign to student if item assigned expired already" do
        expires_on = Date.today + 1.year
        @item.assign_to_student(@student, Date.today - 1.year)
     
        assert_difference "ItemConnection.count", 1 , "Should have created a new ItemConnection" do
          @item.assign_to_student(@student, expires_on)
        end
     end

     should "be withheld from student" do
     
       item_connection = ItemConnection.new
       item_connection.student = @student
       item_connection.item = @item
       item_connection.save
     
       assert_difference "ItemConnection.count", -1 do
         @item.withhold_from_student(@student)
       end
     end
   end
 
 

 
 
end
