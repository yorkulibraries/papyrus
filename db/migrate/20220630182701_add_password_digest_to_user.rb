class AddPasswordDigestToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :encrypted_password, :string
    add_index :users, :email, unique: true
  end
end
