# frozen_string_literal: true

class CreateScanLists < ActiveRecord::Migration[4.2]
  def change
    create_table :scan_lists do |t|
      t.string :name
      t.integer :created_by_id
      t.integer :assigned_to_id
      t.string :status

      t.timestamps null: false
    end
  end
end
