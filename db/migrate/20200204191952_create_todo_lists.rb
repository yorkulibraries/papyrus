class CreateTodoLists < ActiveRecord::Migration[4.2]
  def change
    create_table :todo_lists do |t|
      t.string :name
      t.integer :created_by_id
      t.integer :assigned_to_id
      t.string :status

      t.timestamps null: false
    end
  end
end
