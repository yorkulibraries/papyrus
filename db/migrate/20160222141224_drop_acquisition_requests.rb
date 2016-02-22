class DropAcquisitionRequests < ActiveRecord::Migration
  def change
    drop_table :acquisition_requests
  end
end
