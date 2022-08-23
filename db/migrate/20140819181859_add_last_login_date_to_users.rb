# frozen_string_literal: true

class AddLastLoginDateToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :last_logged_in_at, :datetime
  end
end
