# frozen_string_literal: true

class AddCounterCaches < ActiveRecord::Migration[4.2]
  def up
    add_column :items, :attachments_count, :integer, default: 0, null: false
    add_column :terms, :courses_count, :integer, default: 0, null: false
    add_column :courses, :items_count, :integer, default: 0, null: false
  end

  def down
    remove_column :items, :attachments_count
    remove_column :terms, :courses_count
    remove_column :courses, :items_count
  end
end
