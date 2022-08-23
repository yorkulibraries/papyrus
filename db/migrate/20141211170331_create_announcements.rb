# frozen_string_literal: true

class CreateAnnouncements < ActiveRecord::Migration[4.2]
  def change
    create_table :announcements do |t|
      t.text :message
      t.string :audience
      t.boolean :active, default: false
      t.integer :user_id
      t.datetime :starts_at
      t.datetime :ends_at

      t.timestamps
    end
  end
end
