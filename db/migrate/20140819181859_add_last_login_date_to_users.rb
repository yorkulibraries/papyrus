class AddLastLoginDateToUsers < ActiveRecord::Migration
  def change
    add_column :users, :last_logged_in_at, :datetime
  end
end
