class AddCourseCodeToItems < ActiveRecord::Migration[5.1]
  def change
    add_column :items, :course_code, :string
  end
end
