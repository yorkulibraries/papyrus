class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.string :name
      t.string :attachment
      t.integer :attachable_id
      t.string :attachable_type
      t.integer :user_id, default: 0
      t.boolean :deleted, default: false

      t.timestamps null: false
    end
  end
end
