class CreateScanItems < ActiveRecord::Migration
  def change
    create_table :scan_items do |t|
      t.string :summary
      t.integer :item_id
      t.integer :scan_list_id
      t.integer :assigned_to_id
      t.integer :created_by_id
      t.date :due_date
      t.string :status

      t.timestamps null: false
    end
  end
end
