class AddFieldsToStudentDetails < ActiveRecord::Migration
  def change
    add_column :student_details, :requires_orientation, :boolean, default: true, null: false
    add_column :student_details, :orientation_completed, :boolean, default: false, null: false
    add_column :student_details, :orientation_completed_at, :date, default: nil
  end
end
