# frozen_string_literal: true

class InstallActsAsAudited < ActiveRecord::Migration[4.2]
  def self.up
    create_table :audits, force: true do |t|
      t.integer  :auditable_id
      t.string   :auditable_type
      t.integer  :associated_id
      t.string   :associated_type
      t.integer  :user_id
      t.string   :user_type
      t.string   :username
      t.string   :action
      t.text     :audited_changes
      t.integer  :version, default: 0
      t.string   :comment
      t.string   :remote_address
      t.datetime :created_at
    end

    add_index :audits, %i[associated_id associated_type], name: 'associated_index'
    add_index :audits, %i[auditable_id auditable_type], name: 'auditable_index'
    add_index :audits, [:created_at], name: 'index_audits_on_created_at'
    add_index :audits, %i[user_id user_type], name: 'user_index'
  end

  def self.down
    drop_table :audits
  end
end
