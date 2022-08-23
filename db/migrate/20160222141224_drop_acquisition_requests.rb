# frozen_string_literal: true

class DropAcquisitionRequests < ActiveRecord::Migration[4.2]
  def change
    drop_table :acquisition_requests if ActiveRecord::Base.connection.table_exists? 'acquisition_requests'
  end
end
