class AddSyllabusIdToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :syllabus_id, :integer
  end
end
