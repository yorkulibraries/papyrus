class AddFirstTimeLoginToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :first_time_login, :boolean, default: true
  end
end
