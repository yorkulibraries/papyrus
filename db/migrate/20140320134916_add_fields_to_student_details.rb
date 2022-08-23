# frozen_string_literal: true

class AddFieldsToStudentDetails < ActiveRecord::Migration[4.2]
  def change
    add_column :student_details, :requires_orientation, :boolean, default: true, null: false
    add_column :student_details, :orientation_completed, :boolean, default: false, null: false
    add_column :student_details, :orientation_completed_at, :date, default: nil
  end
end
