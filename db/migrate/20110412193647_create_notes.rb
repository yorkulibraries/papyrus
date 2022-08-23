# frozen_string_literal: true

class CreateNotes < ActiveRecord::Migration[4.2]
  def self.up
    create_table :notes do |t|
      t.text :note
      t.integer :student_id
      t.integer :user_id, default: 0
      t.timestamps
    end
  end

  def self.down
    drop_table :notes
  end
end
