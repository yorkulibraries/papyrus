class AddNoteBackOrderedFieldsToAcquisitionRequests < ActiveRecord::Migration
  def change
    add_column :acquisition_requests, :note, :string
    add_column :acquisition_requests, :back_ordered_until, :date
    add_column :acquisition_requests, :back_ordered_reason, :string
    add_column :acquisition_requests, :back_ordered_by_id, :integer    
  end
end
