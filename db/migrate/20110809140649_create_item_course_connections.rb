class CreateItemCourseConnections < ActiveRecord::Migration
  def self.up
    create_table :item_course_connections do |t|
      t.references :item
      t.references :course
      t.timestamps
    end
  end

  def self.down
    drop_table :item_course_connections
  end
end
