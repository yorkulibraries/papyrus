# frozen_string_literal: true

class CreateSettings < ActiveRecord::Migration[4.2]
  def self.up
    create_table :settings do |t|
      t.string :var, null: false
      t.text   :value, null: true
      t.integer :thing_id, null: true
      t.string :thing_type, limit: 30, null: true
      t.timestamps
    end

    add_index :settings, %i[thing_type thing_id var], unique: true
  end

  def self.down
    drop_table :settings
  end
end
