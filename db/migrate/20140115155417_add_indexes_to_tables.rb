class AddIndexesToTables < ActiveRecord::Migration
  def change
    add_index :users, [:inactive, :role]

    add_index :terms, [:end_date]
    add_index :courses, [:term_id]
    add_index :item_course_connections, [:course_id, :item_id]


    add_index :item_connections, [:expires_on, :item_id],  name: "ic_e_i_index"
    add_index :item_connections, [:expires_on, :student_id],  name: "ic_e_s_index"
    add_index :item_connections, [:student_id, :item_id, :expires_on],  name: "ic_s_i_e_index"

    add_index :attachments, [:item_id, :deleted]
    add_index :notes, [:student_id]


    add_index :acquisition_requests, [:item_id]
  end
end
