class AddCounterCaches < ActiveRecord::Migration
  def up
    add_column :items, :attachments_count, :integer, default: 0, null: false
    add_column :students, :notes_count, :integer, default: 0, null: false
    add_column :terms, :courses_count, :integer, default: 0, null: false
    add_column :courses, :items_count, :integer, default: 0, null: false
  end

  def down
    remove_column :items, :attachments_count
    remove_column :students, :notes_count
    remove_column :terms, :courses_count
    remove_column :courses, :items_count            
  end
end
