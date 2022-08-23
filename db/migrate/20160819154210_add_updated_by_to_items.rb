# frozen_string_literal: true

class AddUpdatedByToItems < ActiveRecord::Migration[4.2]
  def change
    add_column :items, :updated_by, :integer
  end
end
