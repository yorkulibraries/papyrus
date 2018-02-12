class CreateAttachments < ActiveRecord::Migration[4.2]
  def self.up
    create_table :attachments do |t|
      t.string :name
      t.integer :item_id
      t.string :file
      t.boolean :full_text, default: false
      t.boolean :deleted, default: false
      t.integer :user_id, default: 0
      t.timestamps
    end
  end

  def self.down
    drop_table :attachments
  end
end
