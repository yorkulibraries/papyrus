class CreateAcquisitionRequests < ActiveRecord::Migration[4.2]
  def change
    create_table :acquisition_requests do |t|
      t.integer :item_id
      t.integer :requested_by_id
      t.text :acquisition_reason
      t.string :status
      t.integer :cancelled_by_id
      t.text :cancellation_reason
      t.datetime :cancelled_at
      t.integer :acquired_by_id
      t.datetime :acquired_at
      t.text :acquisition_notes
      t.text :acquisition_source_type
      t.text :acquisition_source_name
      t.timestamps
    end

  end
end
