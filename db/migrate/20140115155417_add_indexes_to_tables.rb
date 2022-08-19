class AddIndexesToTables < ActiveRecord::Migration[4.2]
  def change
    add_index :users, %i[inactive role]

    add_index :terms, [:end_date]
    add_index :courses, [:term_id]
    add_index :item_course_connections, %i[course_id item_id]

    add_index :item_connections, %i[expires_on item_id], name: 'ic_e_i_index'
    add_index :item_connections, %i[expires_on student_id], name: 'ic_e_s_index'
    add_index :item_connections, %i[student_id item_id expires_on], name: 'ic_s_i_e_index'

    add_index :attachments, %i[item_id deleted]
    add_index :notes, [:student_id]
  end
end
