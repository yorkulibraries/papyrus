class FixIndexes < ActiveRecord::Migration[4.2]
  def change
    # remove long named indexes
    remove_index :item_course_connections, %i[course_id item_id] if index_exists?(:item_course_connections,
                                                                                  %i[course_id item_id])
    remove_index :item_connections, %i[expires_on item_id] if index_exists?(:item_connections, %i[student_id item_id])
    remove_index :item_connections, %i[expires_on student_id] if index_exists?(:item_connections,
                                                                               %i[student_id expires_on])
    remove_index :item_connections, %i[student_id item_id expires_on] if index_exists?(:item_connections,
                                                                                       %i[student_id item_id
                                                                                          expires_on])

    # add shorter named indexes
    add_index :item_course_connections, %i[course_id item_id], name: 'icc_c_i_index' unless index_exists?(
      :item_course_connections, %i[course_id item_id], name: 'icc_c_i_index'
    )

    add_index :item_connections, %i[expires_on item_id], name: 'ic_e_i_index' unless index_exists?(:item_connections,
                                                                                                   %i[expires_on item_id], name: 'ic_e_i_index')
    add_index :item_connections, %i[expires_on student_id], name: 'ic_e_s_index' unless index_exists?(
      :item_connections, %i[expires_on student_id], name: 'ic_e_s_index'
    )
    add_index :item_connections, %i[student_id item_id expires_on], name: 'ic_s_i_e_index' unless index_exists?(
      :item_connections, %i[student_id item_id expires_on], name: 'ic_s_i_e_index'
    )
  end
end
