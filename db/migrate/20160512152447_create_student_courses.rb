class CreateStudentCourses < ActiveRecord::Migration[4.2]
  def change
    create_table :student_courses do |t|
      t.integer :student_id
      t.integer :course_id

      t.timestamps null: false
    end
  end
end
