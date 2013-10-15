class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :username
      t.string :name
      t.string :role
      t.boolean  :inactive, default: false
      t.string   :type
      t.string   :email
      t.integer  :created_by_user_id
      t.datetime :email_sent_at
      t.boolean  :blocked, default: false
      t.timestamps
    end
  end


  def self.down
    drop_table :users
  end
end
