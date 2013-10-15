class CreateAcquisitionRequests < ActiveRecord::Migration
  def self.up
    create_table :acquisition_requests do |t|
      t.integer :item_id
      t.integer :requested_by_id
      t.date :requested_by_date
      t.integer :fulfilled_by_id
      t.date :fulfilled_by_date
      t.boolean :fulfilled, default: false
      t.boolean :cancelled, default: false
      t.integer :cancelled_by_id
      t.date :cancelled_by_date
      t.text :notes
      t.timestamps
    end
  end

  def self.down
    drop_table :acquisition_requests
  end
end
