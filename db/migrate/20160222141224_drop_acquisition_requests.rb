class DropAcquisitionRequests < ActiveRecord::Migration
  def change
    drop_table :acquisition_requests if ActiveRecord::Base.connection.table_exists? "acquisition_requests"
  end
end
