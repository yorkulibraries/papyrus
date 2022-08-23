# frozen_string_literal: true

class AddTitleAndDateIndexToItems < ActiveRecord::Migration[5.1]
  def change
    add_index :items, :created_at
    add_index :items, :title
  end
end
