class FixIndexes < ActiveRecord::Migration
  def change

    # remove long named indexes
    remove_index :item_course_connections, [:course_id, :item_id]
    remove_index :item_connections, [:expires_on, :item_id]
    remove_index :item_connections, [:expires_on, :student_id]
    remove_index :item_connections, [:student_id, :item_id, :expires_on]


    # add shorter named indexes
    add_index :item_course_connections, [:course_id, :item_id],  name: "icc_c_i_index"

    add_index :item_connections, [:expires_on, :item_id],  name: "ic_e_i_index"
    add_index :item_connections, [:expires_on, :student_id],  name: "ic_e_s_index"
    add_index :item_connections, [:student_id, :item_id, :expires_on],  name: "ic_s_i_e_index"

  end
end
