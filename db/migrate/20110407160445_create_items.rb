class CreateItems < ActiveRecord::Migration[4.2]
  def self.up
    create_table :items do |t|
      t.string :title
      t.string :unique_id
      t.string :item_type
      t.string :callnumber
      t.string :author
      t.integer  :user_id, default: 0
      t.string   :isbn
      t.string   :published_date
      t.string   :publisher
      t.string   :edition
      t.string   :physical_description
      t.string   :language_note
      t.string   :source
      t.string   :source_note
      t.timestamps
    end

    add_index :items, :unique_id
    add_index :items, :user_id
  end


  def self.down
    drop_table :items
  end
end
