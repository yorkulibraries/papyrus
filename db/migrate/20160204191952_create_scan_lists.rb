class CreateScanLists < ActiveRecord::Migration
  def change
    create_table :scan_lists do |t|
      t.string :name
      t.integer :created_by_id
      t.interer :assigned_to_id
      t.string :status

      t.timestamps null: false
    end
  end
end
