class CreateAppointments < ActiveRecord::Migration[4.2]
  def change
    create_table :appointments do |t|
      t.integer :student_id
      t.string :title
      t.integer :user_id
      t.datetime :at
      t.text :note
      t.boolean :completed, default: false

      t.timestamps null: false
    end
  end
end
