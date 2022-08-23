# frozen_string_literal: true

class CreateStudents < ActiveRecord::Migration[4.2]
  def self.up
    create_table :students do |t|
      t.string :name
      t.string :email
      t.string :username
      t.string   :student_number
      t.integer  :user_id, default: 0

      t.timestamps
    end
  end

  def self.down
    drop_table :students
  end
end
