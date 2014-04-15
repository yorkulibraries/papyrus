class CreateAccessCodes < ActiveRecord::Migration
  def self.up
    create_table :access_codes do |t|
      t.string :for
      t.string :code
      t.date :expires_at
      t.integer :student_id
      t.integer :created_by_id
      t.timestamps
    end
  end

  def self.down
    drop_table :access_codes
  end
end
