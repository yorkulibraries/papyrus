class AddUpdatedByToItems < ActiveRecord::Migration
  def change
    add_column :items, :updated_by, :integer
  end
end
