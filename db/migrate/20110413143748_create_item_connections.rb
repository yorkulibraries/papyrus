class CreateItemConnections < ActiveRecord::Migration
  def self.up
    create_table :item_connections do |t|
      t.integer :item_id
      t.integer :student_id
      t.date :expires_on
      t.timestamps
    end
  end  

  def self.down
    drop_table :item_connections
  end
end
