# frozen_string_literal: true

class AddPasswordDigestToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :encrypted_password, :string
    add_index :users, :email, unique: true
    add_column :students, :encrypted_password, :string
  end
end
